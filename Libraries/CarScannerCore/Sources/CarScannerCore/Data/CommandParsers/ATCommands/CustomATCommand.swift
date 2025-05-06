//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 23.04.2025.
//

import Foundation

public final class CustomATCommand: ATCommandItem {
    public var command: String
    public var description: String { "Disable echo" }

    public func parse(response: String) throws -> ATCommandResult {
        .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
    public init(command: String) {
        self.command = command
    }
}
