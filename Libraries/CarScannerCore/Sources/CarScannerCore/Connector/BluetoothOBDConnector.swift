//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import CoreBluetooth
import Combine

//public final class BluetoothOBDConnector: NSObject, OBDConnector, CBCentralManagerDelegate, CBPeripheralDelegate {
//    @Published private var connections: [OBDConnectionModel] = []
//    private var connectionsPeripheral: [CBPeripheral] = []
//    private var continuation: CheckedContinuation<OBDTransport, Error>?
//    private let knownOBDUUIDs: [CBUUID] = [
//        CBUUID(string: "FFF0"),
//        CBUUID(string: "FFE0"),
//        CBUUID(string: "18F0"),
//        CBUUID(string: "1101")
//    ]
//    
//    public var dicoveredConnections: AnyPublisher<[OBDConnectionModel], Never> {
//        $connections.eraseToAnyPublisher()
//    }
//        
//    private var needFirstScan = false
//    private var needReconnect = false
//    
//    public override init() {
//        super.init()
//        CentralManagerProvider.shared.centralManager.delegate = self
//    }
//    
//    public func startScan() {
//        connectionsPeripheral.removeAll()
//        if CentralManagerProvider.shared.centralManager.state == .poweredOn {
//            CentralManagerProvider.shared.centralManager.scanForPeripherals(withServices: knownOBDUUIDs)
//        } else {
//            needFirstScan = true
//        }
//    }
//    
//    public func stopScan() {
//        needFirstScan = false
//        CentralManagerProvider.shared.centralManager.stopScan()
//    }
//    
//    public func reconnect() async throws -> OBDTransport {
//        CentralManagerProvider.shared.centralManager.delegate = self
//        
//        return try await withCheckedThrowingContinuation { [weak self] continuation in
//            self?.continuation = continuation
//            if CentralManagerProvider.shared.centralManager.state == .poweredOn, let id = UserDefaults.standard.string(forKey: UserDefaultKey.obdID.rawValue), let uuid = UUID(uuidString: id) {
//                if let first = CentralManagerProvider.shared.centralManager.retrievePeripherals(withIdentifiers: [uuid]).first {
//                    CentralManagerProvider.shared.centralManager.connect(first)
//                } else {
//                    self?.continuation?.resume(throwing: OBDConnectorError.failedConnection)
//                }
//            } else {
//                self?.needReconnect = true
//            }
//        }
//    }
//    
//    public func connect(id: String) async throws -> OBDTransport {
//        
//        if let peripheral = connectionsPeripheral.first(where: { $0.identifier.uuidString == id }) {
//            if peripheral.state == .connected {
//                return BluetoothOBDTransport(peripheral: peripheral)
//            }
//            return try await withCheckedThrowingContinuation { [weak self] continuation in
//                self?.continuation = continuation
//                CentralManagerProvider.shared.centralManager.connect(peripheral)
//                CentralManagerProvider.shared.centralManager.stopScan()
//            }
//        }
//        throw OBDConnectorError.notFound
//    }
//    
//    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        connectionsPeripheral.append(peripheral)
//        if !connections.contains(where: { $0.id == peripheral.identifier.uuidString }) {
//            if let name = peripheral.name {
//                connections.append(.init(name: name, id: peripheral.identifier.uuidString, isConnected: peripheral.state == .connected))
//            }
//        }
//    }
//    
//    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn, needFirstScan {
//            needFirstScan = false
//            CentralManagerProvider.shared.centralManager.scanForPeripherals(withServices: knownOBDUUIDs)
//        }
//        
//        if central.state == .poweredOn, needReconnect, let id = UserDefaults.standard.string(forKey: UserDefaultKey.obdID.rawValue), let uuid = UUID(uuidString: id) {
//            if let first = CentralManagerProvider.shared.centralManager.retrievePeripherals(withIdentifiers: [uuid]).first {
//                CentralManagerProvider.shared.centralManager.connect(first)
//            } else {
//                continuation?.resume(throwing: OBDConnectorError.failedConnection)
//            }
//            needReconnect = false
//        }
//    }
//    
//    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        let transport = BluetoothOBDTransport(peripheral: peripheral)
//        OBDTransportProvider.shared.setupTransport(transport: transport)
//        UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: UserDefaultKey.obdID.rawValue)
//        continuation?.resume(returning: transport)
//    }
//    
//    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
//        continuation?.resume(throwing: OBDConnectorError.failedConnection)
//    }
//    
//    public func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
//    }
//}
