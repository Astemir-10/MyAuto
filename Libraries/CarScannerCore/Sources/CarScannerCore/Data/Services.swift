//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import Combine
/*
 DefaultOBDExecutor — это ядро логики модуля, связующее звено между:
 •    выбранным транспортом (BluetoothOBDTransport, WiFiOBDTransport),
 •    командами (OBDCommand),
 •    и клиентским кодом (то, что вызывает диагностику)
 
 Что делает DefaultOBDExecutor:
 
 1. Принимает команду (OBDCommand)
 
 2. Отправляет строку команды через транспорт
 
 3. Получает и парсит ответ
 
 4. Возвращает результат (OBDResult)
 */


enum OBDExecutorError: Error {
    case notConnected
}

extension ConnectionState: Equatable {
    public static func == (lhs: ConnectionState, rhs: ConnectionState) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected),
             (.connecting, .connecting),
             (.connected, .connected):
            return true
        case (.error, .error):
            return true // или false, если ошибки важно различать
        default:
            return false
        }
    }
}


final class DefaultOBDExecutor: OBDExecutor {
    private let transport: OBDTransport
    
    // Хранимое состояние
    @Published private var connectionState: ConnectionState = .disconnected
    
    // Combine publisher
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> {
        $connectionState.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(transport: OBDTransport) {
        self.transport = transport
        transport.statePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] transportState in
                    self?.handleTransportStateChange(transportState)
                }
                .store(in: &cancellables)
    }
    
    func connect() async throws {
//        guard connectionState != .connecting else { return }
//        
//        await updateState(.connecting)
//        do {
//            try await transport.connect()
//            await updateState(.connected)
//        } catch {
//            await updateState(.error(error))
//            throw error
//        }
    }
    
    func disconnect() async throws {
//        transport.disconnect()
//        await updateState(.disconnected)
    }
    
    func execute(command: OBDCommandItem) async throws -> OBDResult {
        guard transport.isConnected else {
            throw OBDExecutorError.notConnected
        }
        
        let raw = try await transport.send(command: command)
        return try command.parse(response: raw)
    }
    
    private func updateState(_ newState: ConnectionState) async {
        await MainActor.run {
            self.connectionState = newState
        }
    }
    
    private func handleTransportStateChange(_ transportState: TransportState) {
        switch transportState {
        case .connected:
            connectionState = .connected
        case .connecting:
            connectionState = .connecting
        case .disconnected:
            connectionState = .disconnected
        case .failed(let error):
            connectionState = .error(error)
        case .disconnecting:
            connectionState = .disconnected
        }
    }
}
