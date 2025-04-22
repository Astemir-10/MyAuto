//
//  File 4.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

public final class SetProtocolCommand: ATCommandItem {
    let protocolNumber: Int
    
    public init(protocolNumber: Int) {
        self.protocolNumber = protocolNumber
    }
    
    public var command: String { "ATSP\(protocolNumber)" }
    public var description: String { "Set protocol to \(protocolNumber)" }
    
    public func parse(response: String) throws -> ATCommandResult {
        return .init(rawResponse: response, isSuccess: response.contains("OK"))
    }
    
}
