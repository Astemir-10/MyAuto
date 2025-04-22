//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation

protocol ATCommandExecutor {
    func execute(_ command: any CommandItem) async throws -> ATCommandResult
}
