//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation
import CoreBluetooth

enum TransportError: Error {
    case invalidCommand, invalidResponse, notReady
}

final class CommandQueueProcessor {
    private var queue: [OBDCommand] = []
    private var isProcessing = false

    private weak var transport: OBDCommandSending?
    private var responseBuffer = ""
    private let responseTerminator = ">" // может быть параметром

    init(transport: OBDCommandSending) {
        self.transport = transport
    }

    func enqueue(_ command: OBDCommandItem) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let cmd = OBDCommand(command: command, continuation: continuation)
            queue.append(cmd)
            processNext()
        }
    }

    private func processNext() {
        guard !isProcessing, let next = queue.first else { return }

        guard let data = (next.command.command + "\r").data(using: .utf8) else {
            next.continuation.resume(throwing: TransportError.invalidCommand)
            queue.removeFirst()
            processNext()
            return
        }

        do {
            try transport?.sendRaw(data)
            isProcessing = true
        } catch {
            next.continuation.resume(throwing: error)
            queue.removeFirst()
            processNext()
        }
    }

    func handleResponse(data: Data) {
        guard !queue.isEmpty else { return }

        if let chunk = String(data: data, encoding: .utf8) {
            responseBuffer += chunk

            if responseBuffer.contains(responseTerminator) {
                let current = queue.removeFirst()
                let cleaned = responseBuffer.replacingOccurrences(of: responseTerminator, with: "").trimmingCharacters(in: .whitespacesAndNewlines)

                current.continuation.resume(returning: cleaned)
                responseBuffer = ""
                isProcessing = false
                processNext()
            }
        } else {
            let current = queue.removeFirst()
            current.continuation.resume(throwing: TransportError.invalidResponse)
            isProcessing = false
            processNext()
        }
    }
}
