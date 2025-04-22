//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 19.04.2025.
//

import Foundation

public final class MAFCommand: OBDCommandItem {
    public var command: String { "0110" }
    public var description: String { "Mass Air Flow" }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        guard bytes.count >= 6, bytes[2] == "41", bytes[3] == "10",
              let A = Int(bytes[4], radix: 16), let B = Int(bytes[5], radix: 16) else {
            throw OBDParsingError.invalidWithMessage(message: "Invalid MAF")
        }
        let maf = Double((A * 256) + B) / 100.0
        return .maf(maf)
    }

    public init() {}
}
