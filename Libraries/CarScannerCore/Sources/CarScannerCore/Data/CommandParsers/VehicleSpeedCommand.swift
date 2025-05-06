//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

/// Команда для получения текущей скорости автомобиля
/// PID: 010D
/// Формула: A
/// Единицы измерения: км/ч
public final class VehicleSpeedCommand: OBDCommandItem {
    public var command: String { "010D" }
    public var description: String { "Vehicle Speed" }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        // Проверяем длину и формат ответа
        guard bytes.count >= 5,
              bytes[2] == "41",
              bytes[3] == "0D" else {
            throw OBDParsingError.invalidWithMessage(message: "Not a valid speed response")
        }
        
        // Безопасно конвертируем байт скорости
        guard let speed = Int(bytes[4], radix: 16) else {
            throw OBDParsingError.invalidWithMessage(message: "Invalid speed byte")
        }
        
        return .speed(speed)  // Возвращаем скорость в км/ч
    }

    public init() {}
}
