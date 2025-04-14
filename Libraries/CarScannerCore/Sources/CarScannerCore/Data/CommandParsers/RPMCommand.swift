//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

final class RPMCommand: OBDCommandItem {
    var command: String { "010C" } // PID для RPM

    func parse(response: String) throws -> OBDResult {
        let bytes = response.split(separator: " ")
        guard bytes.count >= 4 else { throw OBDParsingError.invalidResponse }

        let A = Int(bytes[2], radix: 16)!
        let B = Int(bytes[3], radix: 16)!
        let rpm = ((A * 256) + B) / 4
        return .rpm(rpm)
    }
}
