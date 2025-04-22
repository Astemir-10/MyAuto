//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Architecture
import CarScannerCore

protocol CarScannerRouterInput: RouterInput {
    func openBLEScanner(connector: OBDConnector, moduleOutput: BLEScannerModuleOutput)
    func openConsole(queueCommands: [String])
}

final class CarScannerRouter: CarScannerRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    func openBLEScanner(connector: OBDConnector, moduleOutput: BLEScannerModuleOutput) {
        let vc = BLEScannerAssembly.assemblyBLE(connector: connector, moduleOutput: moduleOutput)
        transitionHandler.present(vc)
    }
    
    func openConsole(queueCommands: [String]) {
        let consoleVC = ConsoleVC()
        consoleVC.commands = queueCommands
        transitionHandler.present(consoleVC)
    }
}
