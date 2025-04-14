//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 14.04.2025.
//

import Foundation

protocol OBDCommandSending: AnyObject {
    func sendRaw(_ data: Data) throws
}
