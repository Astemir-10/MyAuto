//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 22.04.2025.
//

import Foundation

/// Команда для получения нагрузки на двигатель
/// PID: 0104
/// Формула: A (где A — это нагрузка на двигатель в процентах)
/// Единицы измерения: %
public final class EngineLoadCommand: OBDCommandItem {
    public var command: String { "0104" }
    public var description: String { "Engine Load" }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        
        // Проверяем, что ответ содержит достаточное количество байтов
        guard bytes.count >= 5 else {
            throw OBDParsingError.invalidWithMessage(message: "Response too short")
        }
        
        // Проверяем, что это ответ на 0104 (41 04 ...)
        guard bytes[2] == "41", bytes[3] == "04" else {
            throw OBDParsingError.invalidWithMessage(message: "Not a valid Engine Load response")
        }
        
        // Безопасно конвертируем hex в Int (берём 5-й байт)
        guard let loadHex = Int(bytes[4], radix: 16) else {
            throw OBDParsingError.invalidWithMessage(message: "Invalid hex byte for engine load")
        }
        
        // Нагрузка на двигатель в процентах
        let engineLoad = loadHex
        return .engineLoad(engineLoad)
    }
    
    public init() {}
}
