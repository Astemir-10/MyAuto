//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation
import Combine

final class DefaultOBDLiveSession: OBDLiveSession {
    private let executor: OBDCommandExecutor
    private var commands: [any OBDCommandItem]
    private let interval: TimeInterval
    private var cancellable: AnyCancellable?
    private let subject = PassthroughSubject<OBDCommandResult, Never>()
    private var isPaused: Bool = false

    public var output: AnyPublisher<OBDCommandResult, Never> {
        subject.eraseToAnyPublisher()
    }

    public init(executor: OBDCommandExecutor,
                commands: [any OBDCommandItem],
                interval: TimeInterval = 0.5) {
        self.executor = executor
        self.commands = commands
        self.interval = interval
    }
    
    public func setCommands(commands: [any OBDCommandItem]) {
        self.commands = commands

        if cancellable == nil && !isPaused {
            self.stop()
            self.start()
        }
    }

    public func start() {
        guard cancellable == nil else { return }

        cancellable = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, !self.isPaused else { return }
                self.poll()
            }
    }

    public func stop() {
        cancellable?.cancel()
        cancellable = nil
        isPaused = false
    }

    public func pause() {
        isPaused = true
    }

    public func resume() {
        isPaused = false
    }

    private func poll() {
        Task {
            for command in commands {
                do {
                    let result = try await executor.execute(command: command)
                    subject.send(result)
                } catch {
                    // Можно прокинуть через отдельный errorPublisher
                    print("Live command failed: \(error)")
                }
            }
        }
    }
}
