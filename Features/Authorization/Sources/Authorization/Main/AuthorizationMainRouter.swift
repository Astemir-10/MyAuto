//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import Architecture

protocol AuthorizationMainRouterInput: RouterInput {
    func openRegisterScreen()
}

final class AuthorizationMainRouter: AuthorizationMainRouterInput {
    weak var transitionHandler: TransitionHandler!
 
    func openRegisterScreen() {
        let vc = RegistrationAssembly.assembly()
        transitionHandler.push(vc)
    }
}
