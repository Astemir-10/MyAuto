//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import Combine

public enum TransportState {
    case disconnected
    case connecting
    case connected
    case failed(Error)
}

extension TransportState: Equatable {
    public static func == (lhs: TransportState, rhs: TransportState) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected),
             (.connecting, .connecting),
             (.connected, .connected):
            return true
        case (.failed, .failed):
            return true // или false, если ошибки важно различать
        default:
            return false
        }
    }
}

public protocol OBDTransport {
    var statePublisher: AnyPublisher<TransportState, Never> { get }
    func connect() async throws
    func disconnect()
    func send(command: String) async throws -> String
    var isConnected: Bool { get }
}

/*
 BluetoothOBDTransport
 WiFiOBDTransport
 MockOBDTransport
 */
