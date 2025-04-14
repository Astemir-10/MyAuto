//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import Combine

public struct OBDConnectionModel {
    public let name: String
    public let id: String
    public var isConnected: Bool
}

public enum OBDConnectorError: Error {
    case notFound, failedConnection
}

public protocol OBDConnector {
    var dicoveredConnections: AnyPublisher<[OBDConnectionModel], Never> { get }
    
    func startScan()
    func stopScan()
    func connect(id: String) async throws -> OBDTransport
}
