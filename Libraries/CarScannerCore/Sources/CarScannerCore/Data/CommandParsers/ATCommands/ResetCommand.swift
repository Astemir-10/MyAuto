//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

public enum ATCommandError: Error {
    case emptyResponse
    case unexpectedResponse(String)
    case invalidHexValue
}

public final class ResetCommand: ATCommandItem {
    public var command: String { "ATZ" }
    public var description: String { "Reset adapter" }
    
    public func parse(response: String) throws -> ATCommandResult {
        .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
    public init() { }
}
