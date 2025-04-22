//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 19.04.2025.
//

import Foundation

final class ClearDTCCommand: OBDCommandItem {
    public var command: String { "04" }
    public var description: String { "Clear Trouble Codes" }

    public func parse(response: String) throws -> OBDCommandResult {
        return .clearDTCSuccess
    }
}
