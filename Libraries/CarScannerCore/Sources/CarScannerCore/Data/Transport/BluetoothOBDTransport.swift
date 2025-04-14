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

final class BluetoothOBDTransport: NSObject, CBCentralManagerDelegate, OBDTransport {
    var isConnected: Bool {
        state == .connected
    }
    
    @Published var state: TransportState
    var statePublisher: AnyPublisher<TransportState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    private var centralManager: CBCentralManager!
    private let peripheral: CBPeripheral
    private var writeCharacteristic: CBCharacteristic?
    
    private lazy var queueProcessor = CommandQueueProcessor(transport: self)

    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        switch peripheral.state {
        case .disconnected:
            state = .disconnected
        case .connecting:
            state = .connecting
        case .connected:
            state = .connected
        case .disconnecting:
            state = .disconnecting
        @unknown default:
            state = .failed(TransportError.notReady)
        }
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func send(command: OBDCommandItem) async throws -> String {
        try await queueProcessor.enqueue(command)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
}

extension BluetoothOBDTransport: OBDCommandSending {
    func sendRaw(_ data: Data) throws {
        guard let characteristic = writeCharacteristic else {
            throw TransportError.notReady
        }
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
}

extension BluetoothOBDTransport: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else { return }

        if let data = characteristic.value {
            queueProcessor.handleResponse(data: data)
        }
    }
}
