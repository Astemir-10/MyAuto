//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation


public struct OBDCommand {
    let command: OBDCommandItem
    let continuation: CheckedContinuation<String, Error>
}
