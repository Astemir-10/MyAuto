//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

public enum OBDCommandResult {
    case rpm(Int)
    case speed(Int)
    case troubleCodes([DTCDetail])
    case clearCodes
    case runTime(Double)
    case temperature(Int)
    case throttlePosition(Double)
    case vin(String)
    case maf(Double)
    case dtcs([String])
    case clearDTCSuccess
    case custom(String, Any)
}
