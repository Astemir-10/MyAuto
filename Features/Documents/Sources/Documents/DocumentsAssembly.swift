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

public enum DocumentsAssembly {
    public static func assembly() -> UIViewController {
        let vc = DocumentsViewController()
        
        let router = DocumentsRouter()
        router.transitionHandler = vc
        let navigationController = AppNavigationController(rootViewController: vc)
        let presenter = DocumentsPresenter(view: vc, router: router)
        vc.output = presenter
        return navigationController
    }
}
