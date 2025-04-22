//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import Combine
import CoreBluetooth

public struct OBDConnectionModel {
    public let name: String
    public let id: String
    public var isConnected: Bool
}

public enum OBDConnectorError: Error {
    case notFound, failedConnection, failedReconnection
}

public protocol OBDConnector {
    var dicoveredConnections: AnyPublisher<[OBDConnectionModel], Never> { get }
    func reconnect() async throws
    func startScan()
    func stopScan()
    func connect(id: String) async throws
}

protocol OBDBluetoothConnector {
    func connectedDevice() async -> CBPeripheral?
}
