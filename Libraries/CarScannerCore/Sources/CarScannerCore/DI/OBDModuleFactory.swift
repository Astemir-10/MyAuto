//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation

public enum OBDModuleFactory {
    public static func makeBluetoothOBDExecutor(transport: OBDTransport) -> OBDExecutor {
        return DefaultOBDExecutor(transport: transport)
    }
}
