//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation
/// Команда для получения положения дроссельной заслонки
/// PID: 0111
/// Формула: (100 * A) / 255
/// Единицы измерения: %
final class ThrottlePositionCommand: OBDCommandItem {
    var command: String { "0111" }
    var description: String { "Throttle Position" }

    func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        guard bytes.count >= 3 else {
            throw OBDParsingError.invalidResponse
        }

        // Безопасный парсинг
        guard let rawValue = Int(bytes[2], radix: 16) else {
            throw OBDParsingError.unsupportedFormat
        }

        // Проверка диапазона (0x00–0xFF)
        guard rawValue >= 0 && rawValue <= 255 else {
            throw OBDParsingError.valueOutOfRange
        }

        // Точный расчёт в Double
        let position = (Double(rawValue) / 255.0) * 100.0
        return .throttlePosition(position)
    }
}
