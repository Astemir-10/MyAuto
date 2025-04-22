//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

public struct CommandResponse<C: CommandItem> {
    public let command: C
    public let result: Result<C.Result, Error>
}
