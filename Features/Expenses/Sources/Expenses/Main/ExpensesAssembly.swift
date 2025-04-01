//
//  Calculator.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit
import AppMap
import AppWidgets
import GlobalServiceLocator

public enum ExpensesAssembly {
    public static func assembly() -> UIViewController {
        let vc = ExpensesViewController()
        
        let router = ExpensesRouter()
        router.transitionHandler = vc
        let navigationController = AppNavigationController(rootViewController: vc)
        let presenter = ExpensesPresenter(storage: GlobalServiceLocator.shared.getService(),
                                          view: vc,
                                          router: router)
        vc.output = presenter
        return navigationController
    }
}
