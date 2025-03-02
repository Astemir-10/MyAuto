//
//  File.swift
//  Settings
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import Foundation
import Architecture
import CarInfo

protocol SettingsRouterInput: RouterInput {
    func routeToCarInfoViewController(output: CarInfoModuleOutput)
}

final class SettingsRouter: SettingsRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    func routeToCarInfoViewController(output: CarInfoModuleOutput) {
        let carInfo = CarInfoAssembly.makeModule(moduleOutput: output)
        transitionHandler.present(carInfo)
    }
}


