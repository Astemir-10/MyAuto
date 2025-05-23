//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import CoreBluetooth
import Combine

enum ConnectionError: Error {
    case someError, unknownState, serviceNotFound, characteristicNotFound
}

enum BluetoothError: Error {
    case bluetoothNotAvailable
    case connectionFailed
    case notConnected
}


final class BluetoothOBDTransport: NSObject, OBDTransport {
    
    var isConnected: Bool {
        connectionState.isConnected
    }
    
    @Published var connectionState: OBDModel
    var connectionStatePublisher: AnyPublisher<OBDModel, Never> {
        $connectionState.eraseToAnyPublisher()
    }
    
    @Published var state: TransportState = .unknown
    var transportStatePublisher: AnyPublisher<TransportState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    @Published var discoveredPrh: [OBDModel] = []
    private var discoveredPeripheral: [CBPeripheral] = []
    private var settingNotify = false
    private var settingWrite = false
    
    private var peripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    private var responseContinuation: CheckedContinuation<Data, Error>?
    private var connectorContituation: CheckedContinuation<Void, any Error>?
    
    private lazy var queueProcessor = CommandQueueProcessor(transport: self)
    
    override init() {
        connectionState = .init(name: "", id: "", connectionState: .disconnected)
        super.init()
        CentralManagerProvider.shared.centralManager.delegate = self
        CentralManagerProvider.shared.centralManager.registerForConnectionEvents()
        
        updateTransportState(state: CentralManagerProvider.shared.centralManager.state)
    }
    
    func send(command: any CommandItem) async throws -> String {
        return try await queueProcessor.enqueue(command)
    }
    
    private func updateTransportState(state: CBManagerState) {
        switch state {
        case .unknown:
            self.state = .unknown
        case .resetting:
            self.state = .failed(TransportError.notReady)
        case .unsupported:
            self.state = .unsupported
        case .unauthorized:
            self.state = .unauthorized
        case .poweredOff:
            self.state = .poweredOff
        case .poweredOn:
            self.state = .poweredOn
        @unknown default:
            break
        }
    }
    
    private func updateConnectionState(peripheral: CBPeripheral) {
        switch peripheral.state {
        case .disconnected:
            self.connectionState = .init(name: peripheral.name ?? "OBD",
                                         id: peripheral.identifier.uuidString,
                                         connectionState: .disconnected)
        case .connecting:
            self.connectionState = .init(name: peripheral.name ?? "OBD",
                                         id: peripheral.identifier.uuidString,
                                         connectionState: .connecting)
        case .connected:
            self.connectionState = .init(name: peripheral.name ?? "OBD",
                                         id: peripheral.identifier.uuidString,
                                         connectionState: .connected)
        case .disconnecting:
            self.connectionState = .init(name: peripheral.name ?? "OBD",
                                         id: peripheral.identifier.uuidString,
                                         connectionState: .disconnecting)
        @unknown default:
            self.connectionState = .init(name: peripheral.name ?? "OBD",
                                         id: peripheral.identifier.uuidString,
                                         connectionState: .error(TransportError.notReady))
        }
    }
    
    func reconnect() {
        if let peripheral, peripheral.state != .connected, peripheral.state != .connecting {
            CentralManagerProvider.shared.centralManager.connect(peripheral)
        }
    }
}

extension BluetoothOBDTransport: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        updateTransportState(state: central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.connectorContituation?.resume()
        UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: UserDefaultKey.obdID.rawValue)
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        guard let currentPeripheral = self.peripheral, currentPeripheral.identifier == peripheral.identifier else { return }
        updateConnectionState(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        self.peripheral = nil
        self.connectorContituation?.resume(throwing: OBDConnectorError.failedConnection)
        guard let currentPeripheral = self.peripheral, currentPeripheral.identifier == peripheral.identifier else { return }
        if let error {
            self.connectionState = .init(name: peripheral.name ?? "OBD",
                                         id: peripheral.identifier.uuidString,
                                         connectionState: .error(error))
        } else {
            updateConnectionState(peripheral: peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        guard let currentPeripheral = self.peripheral, currentPeripheral.identifier == peripheral.identifier else { return }
        if let error {
            self.connectionState = .init(name: peripheral.name ?? "OBD",
                                         id: peripheral.identifier.uuidString,
                                         connectionState: .error(error))
        } else {
            updateConnectionState(peripheral: peripheral)
        }
    }
}

extension BluetoothOBDTransport: OBDCommandSending {
    func sendRaw(_ data: Data) throws {
        guard let characteristic = writeCharacteristic else {
            throw TransportError.notReady
        }
        
        peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
}

extension BluetoothOBDTransport: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let currentPeripheral = self.peripheral, currentPeripheral.identifier == peripheral.identifier else { return }
        
        if let data = characteristic.value, String(data: data, encoding: .utf8) != nil {
            queueProcessor.handleResponse(data: data)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard error == nil else { return }
        for service in peripheral.services ?? [] {
            if service.uuid == CBUUID(string: "FFF0") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard error == nil else { return }
        
        for characteristic in service.characteristics ?? [] {
            if characteristic.uuid.uuidString == "FFF2" {
                self.writeCharacteristic = characteristic
                settingWrite = true
                if settingWrite && settingNotify {
                    
                    connectionState = .init(name: peripheral.name ?? "OBD", id: peripheral.identifier.uuidString, connectionState: .ready)
                }
            }
            if characteristic.uuid == CBUUID(string: "FFF1") {
                peripheral.setNotifyValue(true, for: characteristic)
                settingNotify = true
                if settingWrite && settingNotify {
                    connectionState = .init(name: peripheral.name ?? "OBD", id: peripheral.identifier.uuidString, connectionState: .ready)
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredPeripheral.append(peripheral)
        discoveredPrh.append(.init(name: peripheral.name ?? "OBD", id: peripheral.identifier.uuidString, connectionState: peripheral.state.connectionState))
    }
}

extension BluetoothOBDTransport: OBDConnector {
    var dicoveredConnections: AnyPublisher<[OBDModel], Never> {
        $discoveredPrh.eraseToAnyPublisher()
    }
    
    func reconnect() async throws {
        if let savedId = UserDefaults.standard.string(forKey: UserDefaultKey.obdID.rawValue), let uuid = UUID(uuidString: savedId), let peripheral = CentralManagerProvider.shared.centralManager.retrievePeripherals(withIdentifiers: [uuid]).first {
            try await connect(peripheral: peripheral)
        } else {
            throw OBDConnectorError.failedReconnection
        }
    }
    
    func startScan() {
        discoveredPrh.removeAll()
        discoveredPeripheral.removeAll()
        CentralManagerProvider.shared.centralManager.scanForPeripherals(withServices: [CBUUID(string: "FFF0")], options: nil)
    }
    
    func stopScan() {
        CentralManagerProvider.shared.centralManager.stopScan()
    }
    
    func connect(id: String) async throws {
        if let perh = discoveredPeripheral.first(where: { $0.identifier.uuidString == id }) {
            try await withCheckedThrowingContinuation { [weak self] contintuation in
                self?.connectorContituation = contintuation
                CentralManagerProvider.shared.centralManager.connect(perh)
            }
        } else {
            throw OBDConnectorError.notFound
        }
    }
    
    private func connect(peripheral: CBPeripheral) async throws {
        try await withCheckedThrowingContinuation { [weak self] contintuation in
            self?.connectorContituation = contintuation
            CentralManagerProvider.shared.centralManager.connect(peripheral)
        }
    }
}

extension CBPeripheralState {
    var connectionState: ConnectionState {
        switch self {
        case .disconnected:
                .disconnected
        case .connecting:
                .connecting
        case .connected:
                .connected
        case .disconnecting:
                .disconnecting
        @unknown default:
                .error(ConnectionError.someError)
        }
    }
}
