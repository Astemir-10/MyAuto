//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Combine

public protocol OBDLiveSession {
    func start()
    func stop()
    func pause()
    func resume()
    var output: AnyPublisher<OBDResult, Never> { get }
}
