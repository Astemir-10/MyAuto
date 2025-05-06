//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 22.04.2025.
//

import Foundation

/// Команда для получения уровня топлива
/// PID: 012F
/// Формула: A (где A — это уровень топлива в процентах)
/// Единицы измерения: %
public final class FuelLevelCommand: OBDCommandItem {
    public var command: String { "012F" }
    public var description: String { "Fuel Level" }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        // Проверяем, что ответ содержит достаточное количество байтов
        guard bytes.count >= 6 else {
            throw OBDParsingError.invalidWithMessage(message: "Response too short")
        }
        
        // Проверяем, что это ответ на 012F (41 2F ...)
        guard bytes[2] == "41", bytes[3] == "2F" else {
            throw OBDParsingError.invalidWithMessage(message: "Not a valid Fuel Level response")
        }
        
        // Безопасно конвертируем hex в Int (берём 5-й байт)
        guard let fuelLevelHex = Int(bytes[4], radix: 16) else {
            throw OBDParsingError.invalidWithMessage(message: "Invalid hex byte for fuel level")
        }
        
        // Уровень топлива в процентах
        let fuelLevel = fuelLevelHex
        
        return .fuelLevel(fuelLevel)
    }
    
    public init() {}
}
