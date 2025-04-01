//
//  Documents.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit
import AppMap
import AppWidgets
import GlobalServiceLocator

public enum DocumentsAssembly {
    public static func assembly() -> UIViewController {
        let vc = DocumentsViewController()
        
        let router = DocumentsRouter()
        router.transitionHandler = vc
        let navigationController = AppNavigationController(rootViewController: vc)
        let presenter = DocumentsPresenter(storageManager: GlobalServiceLocator.shared.getService(),
                                           fileStorageManager: GlobalServiceLocator.shared.getService(),
                                           view: vc,
                                           router: router)
        vc.output = presenter
        return navigationController
    }
}
