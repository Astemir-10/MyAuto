//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

public struct DTCDetail {
    public let code: String       // Полный код (например, "P0172")
    public let system: String     // Система ("Powertrain", "Chassis" и т.д.)
    public let description: String // Человекочитаемое описание
}

/// Команда для чтения диагностических кодов неисправностей (DTC)
/// Режим: 03
/// Формат ответа: 43 + [коды]
/// Пример кода: P0172
/// Детализированная информация о DTC-коде
final class ReadTroubleCodesCommand: OBDCommandItem {
    var command: String { "03" }
    var description: String { "Read Diagnostic Trouble Codes" }

    func parse(response: String) throws -> OBDCommandResult {
        let bytes = response.split(separator: " ")
        guard bytes.count >= 2, bytes[0] == "43" else {
            throw OBDParsingError.invalidResponse
        }
        
        var codes: [DTCDetail] = []
        for i in stride(from: 1, to: bytes.count, by: 2) {
            if i+1 >= bytes.count { break }
            let firstByte = bytes[i]
            let secondByte = bytes[i+1]
            let dtc = parseDTC(firstByte: firstByte, secondByte: secondByte)
            codes.append(dtc)
        }
        
        return .troubleCodes(codes)
    }
    
    private func parseDTC(firstByte: Substring, secondByte: Substring) -> DTCDetail {
        guard let firstByteValue = Int(firstByte, radix: 16),
              let secondByteValue = Int(secondByte, radix: 16) else {
            return DTCDetail(code: "P0000", system: "Unknown", description: "Invalid DTC code")
        }
        
        // Парсинг типа и цифр кода
        let codeType = (firstByteValue & 0xC0) >> 6
        let firstDigit = (firstByteValue & 0x30) >> 4
        let secondDigit = firstByteValue & 0x0F
        let thirdDigit = (secondByteValue & 0xF0) >> 4
        let fourthDigit = secondByteValue & 0x0F
        
        // Формирование кода
        let typeChar: String
        let system: String
        switch codeType {
        case 0:
            typeChar = "P"
            system = "Powertrain"
        case 1:
            typeChar = "C"
            system = "Chassis"
        case 2:
            typeChar = "B"
            system = "Body"
        case 3:
            typeChar = "U"
            system = "Network"
        default:
            typeChar = "P"
            system = "Unknown"
        }
        
        let code = String(format: "%@%d%X%X%X",
                         typeChar,
                         firstDigit,
                         secondDigit,
                         thirdDigit,
                         fourthDigit)
        
        // Получение описания
        let description = getDTCDescription(code: code)
        
        return DTCDetail(
            code: code,
            system: system,
            description: description
        )
    }
    
    /// Возвращает описание для известных DTC-кодов
    private func getDTCDescription(code: String) -> String {
        switch code {
        // Powertrain (P0xxx)
        case "P0100": return "Mass Air Flow Circuit Malfunction"
        case "P0172": return "System Too Rich (Bank 1)"
        case "P0300": return "Random/Multiple Cylinder Misfire Detected"
        case "P0420": return "Catalyst System Efficiency Below Threshold"
            
        // Chassis (C0xxx)
        case "C0123": return "ABS Pump Motor Circuit Fault"
            
        // Body (B0xxx)
        case "B1000": return "Airbag System Malfunction"
            
        // Network (U0xxx)
        case "U0100": return "Lost Communication with ECM/PCM"
        case "U0121": return "Lost Communication with ABS Control Module"
            
        default:
            return code.starts(with: "P") ? "Powertrain Fault" :
                   code.starts(with: "C") ? "Chassis Fault" :
                   code.starts(with: "B") ? "Body Fault" :
                   code.starts(with: "U") ? "Network Fault" :
                   "Unknown Fault"
        }
    }
}
