//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 22.04.2025.
//

import Foundation


public final class SPCommand: ATCommandItem {
    public var command: String { "AT SP 0" }
    public var description: String { "SP" }

    public func parse(response: String) throws -> ATCommandResult {
        
        print("AT SP 0", response)
        return .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
    public init() { }
}
