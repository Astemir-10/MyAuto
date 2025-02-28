//
//  File.swift
//  Profile
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import Foundation
import Architecture
import CarInfo

protocol ProfileRouterInput: RouterInput {
    func routeToCarInfoViewController(output: CarInfoModuleOutput)
}

final class ProfileRouter: ProfileRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    func routeToCarInfoViewController(output: CarInfoModuleOutput) {
        let carInfo = CarInfoAssembly.makeModule(moduleOutput: output)
        transitionHandler.present(carInfo)
    }
}


