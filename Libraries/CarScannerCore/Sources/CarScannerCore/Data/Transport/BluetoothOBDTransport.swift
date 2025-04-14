//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import CoreBluetooth
import Combine

enum BluetoothError: Error {
    case bluetoothNotAvailable
    case connectionFailed
    case notConnected
}

final class BluetoothOBDTransport: NSObject, OBDTransport, CBCentralManagerDelegate {
    private lazy var manager: CBCentralManager = {
        .init(delegate: self, queue: .global())
    }()
    private let peripheral: CBPeripheral
    
    @Published private var state: TransportState = .disconnected
    var statePublisher: AnyPublisher<TransportState, Never> {
        $state.eraseToAnyPublisher()
    }
        
    var isConnected: Bool {
        state == .connected
    }
    
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()
        print(peripheral.state.rawValue)
    }
    
    func connect() async throws {
    }
    
    func disconnect() {
        
    }
    
    func send(command: String) async throws -> String {
       ""
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("\n\n-----CHANGE STATE----")
        print(central.state.rawValue)
        print("\n\n")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("DID DISCOVER")
        print(peripheral.name)
    }
}
