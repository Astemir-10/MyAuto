//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 23.04.2025.
//

import Foundation

public final class ATMACommand: ATCommandItem {
    public var command: String { "AT MA" }
    public var description: String { "AT MA" }

    public func parse(response: String) throws -> ATCommandResult {
        
        print("AT MA", response)
        return .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
    public init() { }
}
