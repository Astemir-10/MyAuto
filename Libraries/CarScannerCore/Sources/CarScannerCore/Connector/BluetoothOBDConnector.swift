//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import CoreBluetooth
import Combine

public final class BluetoothOBDConnector: NSObject, OBDConnector, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published private var connections: [OBDConnectionModel] = []
    private var connectionsPeripheral: [CBPeripheral] = []
    private var continuation:  CheckedContinuation<OBDTransport, Error>?
    
    public var dicoveredConnections: AnyPublisher<[OBDConnectionModel], Never> {
        $connections.eraseToAnyPublisher()
    }
        
    private var centralManager: CBCentralManager!
    private var needFirstScan = false
    
    public override init() {
        super.init()
        centralManager = .init(delegate: self, queue: .global())
    }
    
    public func startScan() {
        
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        } else {
            needFirstScan = true
        }
    }
    
    public func stopScan() {
        needFirstScan = false
        centralManager.stopScan()
    }
    
    public func connect(id: String) async throws -> OBDTransport {
        if let peripheral = connectionsPeripheral.first(where: { $0.identifier.uuidString == id }) {
            return try await withCheckedThrowingContinuation { [weak self] continuation in
                self?.continuation = continuation
                self?.centralManager.connect(peripheral)
                self?.centralManager.stopScan()
            }
        }
        throw OBDConnectorError.notFound
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        connectionsPeripheral.append(peripheral)
        if !connections.contains(where: { $0.id == peripheral.identifier.uuidString }) {
            if let name = peripheral.name {
                connections.append(.init(name: name, id: peripheral.identifier.uuidString, isConnected: peripheral.state == .connected))
            }
        }
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn, needFirstScan {
            centralManager.scanForPeripherals(withServices: nil)
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        continuation?.resume(returning: BluetoothOBDTransport(peripheral: peripheral))
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        continuation?.resume(throwing: OBDConnectorError.failedConnection)
    }
}
