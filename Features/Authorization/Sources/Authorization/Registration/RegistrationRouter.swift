//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import Architecture

protocol RegistrationRouterInput: RouterInput {
    func confirm(output: ConfirmationModuleOutput, moduleInput: (ConfirmationModuleInput) -> ())
}

final class RegistrationRouter: RegistrationRouterInput {
    
    weak var transitionHandler: TransitionHandler!
    
    func confirm(output: ConfirmationModuleOutput, moduleInput: (ConfirmationModuleInput) -> ()) {
        let vc = ConfirmationAssembly.assembly(moduleOutput: output, moduleInputBuilder: moduleInput)
        transitionHandler.present(vc)
    }
    
}
