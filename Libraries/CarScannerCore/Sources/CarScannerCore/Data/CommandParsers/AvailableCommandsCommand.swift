//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 19.04.2025.
//

import Foundation

public enum OBDMode: String, CaseIterable {
    case currentData = "01"
    case freezeFrame = "02"
    case diagnosticTroubleCodes = "03"
    case clearTroubleCodes = "04"
    case oxygenSensorMonitoring = "05"
    case onboardMonitoring = "06"
    case pendingTroubleCodes = "07"
    case controlOperation = "08"
    case vehicleInfo = "09"
    case permanentTroubleCodes = "0A"

    public var isAvailable: Bool {
        switch self {
        case .currentData, .freezeFrame, .onboardMonitoring, .vehicleInfo:
            return true
        default:
            return false
        }
    }
    
    public var isDTC: Bool {
        switch self {
        case .diagnosticTroubleCodes, .pendingTroubleCodes, .permanentTroubleCodes:
            return true
        default:
            return false
        }
    }
}
public final class AvailableCommandsCommand: OBDCommandItem {
    public var command: String { "\(mode.rawValue)00" }
    public var description: String { "Available Commands" }
    private let mode: OBDMode

    public func parse(response: String) throws -> OBDCommandResult {
        if response.contains("NO DATA") {
            throw OBDParsingError.invalidResponse
        }
        return .custom(command, response)
    }
    
    public init(for mode: OBDMode) {
        self.mode = mode
    }
}
