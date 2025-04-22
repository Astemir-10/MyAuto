//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 19.04.2025.
//

import Foundation

public final class VINCommand: OBDCommandItem {
    public var command: String { "0902" }
    public var description: String { "Vehicle VIN" }

    public func parse(response: String) throws -> OBDCommandResult {
        let cleaned = response.replacingOccurrences(of: "\r", with: "")
        let hexValues = cleaned.split(separator: " ")
        let vinBytes = hexValues.dropFirst(4).compactMap { UInt8($0, radix: 16) }
        let vin = String(bytes: vinBytes, encoding: .ascii) ?? ""
        return .vin(vin)
    }

    public init() {}
}
