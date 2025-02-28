//
//  ProfileAssmebly.swift
//  Profile
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import DesignKit
import GlobalServiceLocator

public enum ProfileAssmebly {
    public static func assembly() -> UIViewController {
        let viewController = ProfileViewController()
        let router = ProfileRouter()
        router.transitionHandler = viewController
        let presenter = ProfilePresenter(storageService: GlobalServiceLocator.shared.getService(),
                                         view: viewController,
                                         router: router)
        let navigationView = AppNavigationController(rootViewController: viewController)
        viewController.output = presenter
        return navigationView
    }
}
