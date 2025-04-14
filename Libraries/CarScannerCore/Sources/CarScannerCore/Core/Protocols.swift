//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

public protocol OBDCommand {
    var command: String { get }
    func parse(response: String) throws -> OBDResult
}
