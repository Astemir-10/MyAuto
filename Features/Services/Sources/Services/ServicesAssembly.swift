//
//  ProfileAssmebly.swift
//  Profile
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import DesignKit
import GlobalServiceLocator

public enum ServicesAssmebly {
    public static func assembly() -> UIViewController {
        let vc = ServicesViewController()
        let router = ServicesRouter()
        router.transitionHandler = vc
        let presenter = ServicesPresenter(view: vc, router: router)
        vc.output = presenter
        return UINavigationController(rootViewController: vc)
    }
}
