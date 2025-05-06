//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit
import GlobalServiceLocator

public enum AuthorizationMainAssembly {
    public static func assembly() -> UIViewController {
        let view = AuthorizationMainViewController()
        let router = AuthorizationMainRouter()
        router.transitionHandler = view
        let presenter = AuthorizationMainPresenter(keychain: GlobalServiceLocator.shared.getService(),
                                                   authService: GlobalServiceLocator.shared.getService(),
                                                   router: router,
                                                   view: view)
        view.output = presenter
        return view
    }
}
