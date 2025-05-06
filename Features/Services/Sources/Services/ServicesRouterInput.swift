//
//  File.swift
//  Profile
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import Foundation
import Architecture
import CarScanner

protocol ServicesRouterInput: RouterInput {
    func openOBDScaenner()
    func openFinesCheck()
    func openDriverCheck()
    func openCarCheck()
}

final class ServicesRouter: ServicesRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    func openOBDScaenner() {
        let carScanner = CarScannerAssembly.assembly()
        transitionHandler.push(carScanner)
    }
    
    func openFinesCheck() {
        let checkVC = CheckFinesAssembly.assembly(mode: .fines)
        transitionHandler.push(checkVC)
    }
    
    func openDriverCheck() {
        let checkVC = CheckFinesAssembly.assembly(mode: .driver)
        transitionHandler.push(checkVC)
    }
    
    func openCarCheck() {
        let checkVC = CheckFinesAssembly.assembly(mode: .car)
        transitionHandler.push(checkVC)
    }
}


