//
//  File 3.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

public final class HeadersOnCommand: ATCommandItem {
    public var command: String { "ATH1" }
    public var description: String { "Enable headers" }
    
    public func parse(response: String) throws -> ATCommandResult {
        .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
    public init() { }
}
