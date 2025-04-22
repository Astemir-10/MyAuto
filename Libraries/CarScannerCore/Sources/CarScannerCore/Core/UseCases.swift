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
    case disconnecting
    case error(Error)
}

protocol OBDCommandExecutor {
    func execute(command: any CommandItem) async throws -> OBDCommandResult
}
