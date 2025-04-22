//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import UIKit
import CarScannerCore

protocol BLEScannerModuleOutput: AnyObject {
    func didConnectDevice(transport: OBDTransport)
}

enum BLEScannerAssembly {
    static func assemblyBLE(connector: OBDConnector, moduleOutput: BLEScannerModuleOutput) -> UIViewController {
        let vc = BLEScannerViewController()
        let presenter = BLEScannerPresenter(moduleOutput: moduleOutput, connector: connector, view: vc)
        vc.output = presenter
        return vc
    }
}
