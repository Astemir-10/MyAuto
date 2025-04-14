//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Architecture

protocol CarScannerRouterInput: RouterInput {
    func openBLEScanner(moduleOutput: BLEScannerModuleOutput)
}

final class CarScannerRouter: CarScannerRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    func openBLEScanner(moduleOutput: BLEScannerModuleOutput) {
        let vc = BLEScannerAssembly.assemblyBLE(moduleOutput: moduleOutput)
        transitionHandler.present(vc)
    }
}
