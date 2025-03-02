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

public enum CalculatorAssembly {
    public static func assembly() -> UIViewController {
        let vc = CalculatorViewController()
        
        let router = CalculatorRouter()
        router.transitionHandler = vc
        let navigationController = AppNavigationController(rootViewController: vc)
        let presenter = CalculatorPresenter(view: vc, router: router)
        vc.output = presenter
        return navigationController
    }
}
