//
//  File 2.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

public final class EchoOffCommand: ATCommandItem {
    public var command: String { "ATE0" }
    public var description: String { "Disable echo" }

    public func parse(response: String) throws -> ATCommandResult {
        .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
    public init() { }
}
