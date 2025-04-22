//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation
import CoreBluetooth

enum TransportError: Error {
    case invalidCommand, invalidResponse, notReady, resetting, unknownState, cancelled, timeout, disconnected
}

final class CommandQueueProcessor {
    private var queue: [Command] = []
    private var isProcessing = false
    private let serialQueue = DispatchQueue(label: "com.carscanner.commandprocessor.serial")
    
    private weak var transport: OBDCommandSending?
    private var responseBuffer = ""
    private let responseTerminator = ">"

    init(transport: OBDCommandSending) {
        self.transport = transport
    }

    func enqueue(_ command: any CommandItem) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            serialQueue.async {
                let cmd = Command(command: command, continuation: continuation)
                self.queue.append(cmd)
                self.processNext()
            }
        }
    }

    private func processNext() {
        serialQueue.async {
            guard !self.isProcessing, let next = self.queue.first else { return }

            guard let data = (next.command.command + "\r").data(using: .utf8) else {
                next.continuation.resume(throwing: TransportError.invalidCommand)
                self.queue.removeFirst()
                self.processNext()
                return
            }

            do {
                try self.transport?.sendRaw(data)
                self.isProcessing = true // Блокируем обработку новых команд
            } catch {
                next.continuation.resume(throwing: error)
                self.queue.removeFirst()
                self.processNext()
            }
        }
    }

    func handleResponse(data: Data) {
        serialQueue.async { [weak self] in
            guard let self, self.isProcessing, !self.queue.isEmpty else { return }
            
            if let chunk = String(data: data, encoding: .utf8) {
                self.responseBuffer += chunk
                
                if self.responseBuffer.contains(self.responseTerminator) {
                    let current = self.queue.removeFirst()
                    let cleaned = self.responseBuffer
                        .replacingOccurrences(of: self.responseTerminator, with: "")
                        .components(separatedBy: .newlines)
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty && $0.uppercased() != current.command.command.uppercased() }
                        .joined(separator: "\n")
                    
                    current.continuation.resume(returning: cleaned)
                    self.responseBuffer = ""
                    self.isProcessing = false
                    self.processNext()
                }
            } else {
                let current = self.queue.removeFirst()
                current.continuation.resume(throwing: TransportError.invalidResponse)
                self.isProcessing = false
                self.processNext()
            }
        }
    }
}
