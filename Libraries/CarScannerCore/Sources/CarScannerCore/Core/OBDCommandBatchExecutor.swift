//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation

struct OBDCommandBatchExecutor {
    private let singleCommandExecutor: (AnyOBDCommandItem) async throws -> OBDCommandResult

    public init(executor: @escaping (AnyOBDCommandItem) async throws -> OBDCommandResult) {
        self.singleCommandExecutor = executor
    }

    public func execute(_ commands: [AnyOBDCommandItem]) async -> [CommandResponse<AnyOBDCommandItem>] {
        var responses: [CommandResponse<AnyOBDCommandItem>] = []

        for command in commands {
            do {
                let result = try await singleCommandExecutor(command)
                responses.append(.init(command: command, result: .success(result)))
            } catch {
                responses.append(.init(command: command, result: .failure(error)))
            }
        }
        
        return responses
    }
}

public struct AnyOBDCommandItem: CommandItem {
    public let command: String
    private let _parse: (String) throws -> OBDCommandResult

    public init<T: CommandItem>(_ wrapped: T) {
        self.command = wrapped.command
        self._parse = wrapped.parse as! (String) throws -> OBDCommandResult
    }

    public func parse(response: String) throws -> OBDCommandResult {
        try _parse(response)
    }
}

extension DefaultOBDExecutor {
    func executeBatch(_ commands: [any OBDCommandItem]) async -> [CommandResponse<AnyOBDCommandItem>] {
        let commands = commands.map({ AnyOBDCommandItem($0) })
        let executor = OBDCommandBatchExecutor { command in
            try await self.execute(command: command)
        }

        return await executor.execute(commands)
    }
}
