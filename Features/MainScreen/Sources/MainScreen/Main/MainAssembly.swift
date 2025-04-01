//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit
import AppMap
import AppWidgets

public enum MainAssembly {
    public static func assembly() -> UIViewController {
        let mainViewController = MainViewController()
        let router = MainRouter()
        let navigationController = AppNavigationController(rootViewController: mainViewController)
        let presenter = MainPresenter(view: mainViewController, router: router)
        mainViewController.output = presenter
        let petrolWidget = PetrolWidgetAssembly.assembly(moduleOutput: presenter,
                                                         transitionHandler: mainViewController)
        
        let weatherWidget = WeatherWidgetAssembly.assembly(widgetOutput: presenter)
        mainViewController.petrolWidget = petrolWidget.0
        mainViewController.weatherWidget = weatherWidget.0
        let mainCar = MainCarInfoAssembly.assembly()
        mainViewController.mainCarInfoViewController = mainCar
        presenter.petrolWidgetModuleInput = petrolWidget.1
        presenter.weatherWidgetModuleInput = weatherWidget.1
        
        return navigationController
    }
}
