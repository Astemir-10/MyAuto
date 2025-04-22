//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation

struct ATCommandBatchExecutor {
    private let singleCommandExecutor: (AnyATCommandItem) async throws -> ATCommandResult

    public init(executor: @escaping (AnyATCommandItem) async throws -> ATCommandResult) {
        self.singleCommandExecutor = executor
    }

    public func execute(_ commands: [AnyATCommandItem]) async -> [CommandResponse<AnyATCommandItem>] {
        var responses: [CommandResponse<AnyATCommandItem>] = []

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

public struct AnyATCommandItem: CommandItem {
    public let command: String
    private let _parse: (String) throws -> ATCommandResult

    public init<T: CommandItem>(_ wrapped: T) {
        self.command = wrapped.command
        self._parse = wrapped.parse as! (String) throws -> ATCommandResult
    }

    public func parse(response: String) throws -> ATCommandResult {
        try _parse(response)
    }
}

extension DefaultATCommandExecutor {
    func executeBatch(_ commands: [any ATCommandItem]) async -> [CommandResponse<AnyATCommandItem>] {
        let commands = commands.map({ AnyATCommandItem($0) })
        let executor = ATCommandBatchExecutor { command in
            try await self.execute(command)
        }
        return await executor.execute(commands)
    }
}
