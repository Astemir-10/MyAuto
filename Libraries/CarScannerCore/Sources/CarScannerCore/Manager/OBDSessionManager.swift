//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation
import Combine


public protocol OBDSessionManager {
    var transportStatePublisher: AnyPublisher<TransportState, Never> { get }
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> { get }
    
    func getConnector() -> OBDConnector?
    func executeOBDCommand<T: OBDCommandItem>(_ item: T) async throws -> OBDCommandResult
    func executeOBDCommands(_ items: [any OBDCommandItem]) async throws -> [CommandResponse<AnyOBDCommandItem>]
    
    func executeATCommand<T: ATCommandItem>(_ item: T) async throws -> ATCommandResult
    func executeATCommands(_ items: [any ATCommandItem]) async throws -> [CommandResponse<AnyATCommandItem>]
    
    func startLiveSession(commands: [any OBDCommandItem]) -> AnyPublisher<OBDCommandResult, Never>
    func pauseLiveSession()
    func resumeLiveSession()
}

final class OBDSessionManagerImpl: OBDSessionManager {
    
    var transportStatePublisher: AnyPublisher<TransportState, Never> {
        transport.transportStatePublisher
    }
    
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> {
        transport.connectionStatePublisher
    }
    
    private let transport: OBDTransport
    private let obdExecutor: OBDCommandExecutor
    private let atExecutor: ATCommandExecutor
    private let liveSession: OBDLiveSession
    
    init() {
        self.transport = BluetoothOBDTransport()
        self.obdExecutor = DefaultOBDExecutor(transport: transport)
        self.atExecutor = DefaultATCommandExecutor(transport: transport)
        self.liveSession = DefaultOBDLiveSession(executor: obdExecutor, commands: [])
    }
    
    func startLiveSession(commands: [any OBDCommandItem]) -> AnyPublisher<OBDCommandResult, Never> {
        self.liveSession.setCommands(commands: commands)
        self.liveSession.start()
        return liveSession.output
    }
    
    func pauseLiveSession() {
        liveSession.pause()
    }
    
    func resumeLiveSession() {
        liveSession.resume()
    }
    
    // MARK: - OBD Commands
    
    func executeOBDCommand<T: OBDCommandItem>(_ item: T) async throws -> OBDCommandResult {
        try await obdExecutor.execute(command: item)
    }
    
    func executeOBDCommands(_ items: [any OBDCommandItem]) async throws -> [CommandResponse<AnyOBDCommandItem>] {
        guard let obdExecutor = obdExecutor as? DefaultOBDExecutor else {
            throw OBDExecutorError.notConnected
        }
        return await obdExecutor.executeBatch(items)
    }
    
    // MARK: - AT Commands
    func executeATCommand<T: ATCommandItem>(_ item: T) async throws -> ATCommandResult {
        return try await atExecutor.execute(item)
    }
    
    func executeATCommands(_ items: [any ATCommandItem]) async throws -> [CommandResponse<AnyATCommandItem>] {
        guard let atExecutor = atExecutor as? DefaultATCommandExecutor else {
            throw ATCommandError.emptyResponse
        }
        return await atExecutor.executeBatch(items)
    }
    
    func getConnector() -> OBDConnector? {
        return transport as? OBDConnector
    }
}
