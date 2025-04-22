//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation
import Combine

final class DefaultOBDExecutor: OBDCommandExecutor {
    
    private let transport: OBDTransport
    
    init(transport: OBDTransport) {
        self.transport = transport
    }

    func execute(command: any CommandItem) async throws -> OBDCommandResult {
        guard transport.isConnected else {
            throw OBDExecutorError.notConnected
        }
        
        let raw = try await transport.send(command: command)
        guard let result = try command.parse(response: raw) as? OBDCommandResult else {
            throw OBDExecutorError.resultType
        }
        return result
    }
}
