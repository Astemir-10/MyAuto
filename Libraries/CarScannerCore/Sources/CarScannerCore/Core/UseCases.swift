//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import Combine

public enum ConnectionState {
    case disconnected
    case connecting
    case connected
    case error(Error)
}

public protocol OBDExecutor {
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> { get }
    func execute(command: OBDCommand) async throws -> OBDResult
    func connect() async throws
    func disconnect() async throws
}
