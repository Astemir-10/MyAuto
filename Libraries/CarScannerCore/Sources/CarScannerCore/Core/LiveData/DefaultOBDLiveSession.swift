//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation
import Combine

public final class DefaultOBDLiveSession: OBDLiveSession {
    private let executor: OBDExecutor
    private let commands: [any OBDCommandItem]
    private let interval: TimeInterval
    private var cancellable: AnyCancellable?
    private let subject = PassthroughSubject<OBDResult, Never>()
    private var isPaused: Bool = false

    public var output: AnyPublisher<OBDResult, Never> {
        subject.eraseToAnyPublisher()
    }

    public init(executor: OBDExecutor,
                commands: [any OBDCommandItem],
                interval: TimeInterval = 0.5) {
        self.executor = executor
        self.commands = commands
        self.interval = interval
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
