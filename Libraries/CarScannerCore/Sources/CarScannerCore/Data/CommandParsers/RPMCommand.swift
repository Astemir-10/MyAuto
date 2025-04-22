//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

/// Команда для получения текущих оборотов двигателя (RPM)
/// PID: 010C
/// Формула: ((A * 256) + B) / 4
/// Единицы измерения: об/мин
public final class RPMCommand: OBDCommandItem {
    public var command: String { "010C" }
    public var description: String { "Engine RPM" }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        
        // Проверяем, что ответ содержит достаточно байтов
        guard bytes.count >= 6 else {
            throw OBDParsingError.invalidWithMessage(message: "Response too short")
        }
        
        // Проверяем, что это ответ на 010C (41 0C ...)
        guard bytes[2] == "41", bytes[3] == "0C" else {
            throw OBDParsingError.invalidWithMessage(message: "Not a valid RPM response")
        }
        
        // Безопасно конвертируем hex в Int (берём 5-й и 6-й байты)
        guard
            let A = Int(bytes[4], radix: 16),  // "0E" → 14
            let B = Int(bytes[5], radix: 16)   // "61" → 97
        else {
            throw OBDParsingError.invalidWithMessage(message: "Invalid hex bytes")
        }
        
        let rpm = ((A * 256) + B) / 4  // (14*256 + 97)/4 = 920.25
        return .rpm(rpm)
    }

    
    public init() {}
}
