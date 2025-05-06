//
//  File 3.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit
import GlobalServiceLocator

public enum RegistrationAssembly {
    static func assembly() -> UIViewController {
        let view = RegistrationViewController()
        let router = RegistrationRouter()
        router.transitionHandler = view
        let presenter = RegistrationPresenter(keychain: GlobalServiceLocator.shared.getService(), authService: GlobalServiceLocator.shared.getService(), router: router, view: view)
        view.output = presenter
        return view
    }

}
