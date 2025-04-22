//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Combine

protocol OBDLiveSession {
    func setCommands(commands: [any OBDCommandItem])
    func start()
    func stop()
    func pause()
    func resume()
    var output: AnyPublisher<OBDCommandResult, Never> { get }
}
