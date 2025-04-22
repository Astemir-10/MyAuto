//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 19.04.2025.
//

import Foundation

public struct DCTModel {
    let mode: OBDMode
    let dctCode: String
    let description: String?
}

public enum OBDLocalizatoin: String {
    case ru, en
}

public final class ReadDTCCommand: OBDCommandItem {
    private let mode: OBDMode
    private let localization: OBDLocalizatoin

    public var command: String { "\(mode.rawValue)" }
    public var description: String { "Read Trouble Codes (mode \(mode))" }
    private lazy var dictionary: [String: String] = {
        loadDTCDescriptions(for: localization.rawValue) ?? [:]
    }()

    public init(localization: OBDLocalizatoin = .ru, mode: OBDMode) {
        self.mode = mode
        self.localization = localization
    }

    public func parse(response: String) throws -> OBDCommandResult {
        let bytes = response
            .replacingOccurrences(of: "\r", with: "")
            .split(separator: " ")
        
        guard bytes.count >= 2 else { throw OBDParsingError.invalidResponse }
        
        var result: [String] = []

        for i in stride(from: 2, to: bytes.count, by: 2) {
            guard i + 1 < bytes.count else { break }
            let b1 = UInt8(bytes[i], radix: 16)!
            let b2 = UInt8(bytes[i+1], radix: 16)!
            
            let type = ["P", "C", "B", "U"][(Int(b1) & 0xC0) >> 6]
            let code = String(format: "%@%01X%02X", type, b1 & 0x3F, b2)
            
            if code != "P0000" {
                result.append(code)
            }
        }

        return .dtcs(result)
    }
    
    func description(for code: String) -> String {
        dictionary[code] ?? "Unknown code"
    }
    
    func loadDTCDescriptions(for language: String) -> [String: String]? {
        guard let url = Bundle.module.url(forResource: "dtc_codes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: [String: String]].self, from: data) else {
            return nil
        }
        
        return decoded.reduce(into: [:]) { result, pair in
            let (code, dict) = pair
            if let localized = dict[language] {
                result[code] = localized
            }
        }
    }
    
    public static func readAllTrubles(localization: OBDLocalizatoin = .ru) -> [any OBDCommandItem] {
        [
            ReadDTCCommand(localization: localization, mode: .diagnosticTroubleCodes),
            ReadDTCCommand(localization: localization, mode: .pendingTroubleCodes),
            ReadDTCCommand(localization: localization, mode: .permanentTroubleCodes),
        ]
    }
}

