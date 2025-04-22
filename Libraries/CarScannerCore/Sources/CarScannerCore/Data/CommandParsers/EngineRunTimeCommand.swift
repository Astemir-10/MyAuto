//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

/// Команда для получения времени работы двигателя с момента запуска
/// PID: 011F
/// Формула: 256 * A + B
/// Единицы измерения: секунды
final class EngineRunTimeCommand: OBDCommandItem {
    var command: String { "011F" }
    var description: String { "Engine Run Time" }

    func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        guard bytes.count >= 4 else {
            throw OBDParsingError.invalidResponse
        }

        // Безопасное преобразование hex → Int
        guard let A = Int(bytes[2], radix: 16),
              let B = Int(bytes[3], radix: 16) else {
            throw OBDParsingError.unsupportedFormat
        }

        // Возвращаем Double для универсальности
        let seconds = Double((A * 256) + B)
        return .runTime(seconds)
    }
}
