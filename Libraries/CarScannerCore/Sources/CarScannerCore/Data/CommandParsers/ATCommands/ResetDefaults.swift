//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 23.04.2025.
//

import Foundation


public final class ResetDefaults: ATCommandItem {
    public var command: String { "ResetDefaults" }
    public var description: String { "reset all settings" }

    public func parse(response: String) throws -> ATCommandResult {
        .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
    public init() {
    }
}
