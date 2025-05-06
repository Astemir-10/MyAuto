//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

/// Команда для получения температуры охлаждающей жидкости
/// PID: 0105
/// Формула: A - 40
/// Единицы измерения: °C
public final class CoolantTempCommand: OBDCommandItem {
    public var command: String { "0105" }
    public var description: String { "Engine Coolant Temperature" }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        guard bytes.count >= 3 else { throw OBDParsingError.invalidResponse }
        
        let temp = Int(bytes[2], radix: 16)! - 40
        return .coolantTemperature(temp)
    }
    
    public init() {}
}
