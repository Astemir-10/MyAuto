//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 19.04.2025.
//

import Foundation

public final class IntakeTempCommand: OBDCommandItem {
    public var command: String { "010F" }
    public var description: String { "Intake Air Temperature" }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        guard bytes.count >= 5, bytes[2] == "41", bytes[3] == "0F",
              let temp = Int(bytes[4], radix: 16) else {
            throw OBDParsingError.invalidWithMessage(message: "Invalid Intake Temp")
        }
        return .temperature(temp - 40)
    }

    public init() {}
}
