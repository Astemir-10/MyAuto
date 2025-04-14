//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

public enum OBDResult {
    case rpm(Int)
    case speed(Int)
    case custom(String, Any)
}
