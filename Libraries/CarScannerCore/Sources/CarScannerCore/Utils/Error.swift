//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

enum OBDParsingError: Error {
    case invalidResponse
    case invalidWithMessage(message: String)
    case unsupportedFormat
    case valueOutOfRange
}
