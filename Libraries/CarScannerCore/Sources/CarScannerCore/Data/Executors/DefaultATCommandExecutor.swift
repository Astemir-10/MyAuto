//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation

enum ATExecutorError: Error {
    case notConnected, resultType
}

final class DefaultATCommandExecutor: ATCommandExecutor {
    private let transport: OBDTransport

    public init(transport: OBDTransport) {
        self.transport = transport
    }

    public func execute(_ command: any CommandItem) async throws -> ATCommandResult {
        let response = try await transport.send(command: command)
        guard let result = try command.parse(response: response) as? ATCommandResult else {
            throw ATExecutorError.resultType
            
        }
        return result
    }
}
