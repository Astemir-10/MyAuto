//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

public protocol CommandItem {
    associatedtype Result
    var command: String { get }
    func parse(response: String) throws -> Result
}

public struct Command {
    public let command: any CommandItem
    public let continuation: CheckedContinuation<String, Error>
}
