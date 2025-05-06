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
        let vc = ProfileViewController()
        let router = ProfileRouter()
        router.transitionHandler = vc
        let presenter = ProfilePresenter(keychain: GlobalServiceLocator.shared.getService(), authService: GlobalServiceLocator.shared.getService(), storageService: GlobalServiceLocator.shared.getService(), view: vc, router: router)
        vc.output = presenter
        return vc
    }
}
