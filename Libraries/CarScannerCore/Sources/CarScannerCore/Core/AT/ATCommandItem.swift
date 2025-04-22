//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation

public protocol ATCommandItem: CommandItem {
    func parse(response: String) throws -> ATCommandResult
}
