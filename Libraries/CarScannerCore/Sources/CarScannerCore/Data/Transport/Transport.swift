//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import Combine

public enum TransportState {
    case poweredOn
    case poweredOff
    case unauthorized
    case unsupported
    case unknown
    case failed(Error)
}

extension TransportState: Equatable {
    public static func == (lhs: TransportState, rhs: TransportState) -> Bool {
        switch (lhs, rhs) {
        case
            (.poweredOn, .poweredOn),
            (.poweredOff, .poweredOff),
            (.unauthorized, .unauthorized),
            (.unsupported, .unsupported):
            return true
        case (.failed, .failed):
            return true // или false, если ошибки важно различать
        default:
            return false
        }
    }
}

public protocol OBDTransport {
    var transportStatePublisher: AnyPublisher<TransportState, Never> { get }
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> { get }
    var isConnected: Bool { get }
    func reconnect()
    func send(command: any CommandItem) async throws -> String
}

/*
 BluetoothOBDTransport
 WiFiOBDTransport
 MockOBDTransport
 */
