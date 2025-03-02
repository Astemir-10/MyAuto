//
//  SettingsAssmebly.swift
//  Settings
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import DesignKit
import GlobalServiceLocator

public enum SettingsAssmebly {
    public static func assembly() -> UIViewController {
        let viewController = SettingsViewController()
        let router = SettingsRouter()
        router.transitionHandler = viewController
        let presenter = SettingsPresenter(storageService: GlobalServiceLocator.shared.getService(),
                                         view: viewController,
                                         router: router)
        let navigationView = AppNavigationController(rootViewController: viewController)
        viewController.output = presenter
        return navigationView
    }
}
