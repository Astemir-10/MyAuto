//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import Foundation
import CoreBluetooth

final class OBDTransportProvider {
    static let shared = OBDTransportProvider()

    private var transport: OBDTransport?

    @discardableResult
    func setupTransport(transport: OBDTransport) -> OBDTransport {
        let newTransport = transport
        self.transport = newTransport
        return newTransport
    }

    func getTransport() -> OBDTransport? {
        return transport
    }

    func resetTransport() {
        transport = nil
    }
}
