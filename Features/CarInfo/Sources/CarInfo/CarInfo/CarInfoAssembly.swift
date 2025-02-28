//
//  CarInfoAssembly.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit
import AppServices
import DesignKit
import GlobalServiceLocator

public protocol CarInfoModuleOutput: AnyObject {
    func didGetCarInfo(carInfoDetailsModel: CarInfoDetailsModel)
}

public enum CarInfoAssembly {
    public static func makeModule(moduleOutput: CarInfoModuleOutput? = nil) -> UIViewController {
        let view = CarInfoViewController()
        let navigationController = AppNavigationController(rootViewController: view)
        let router = CarInfoRouter()
        let presenter = CarInfoPresenter(view: view, router: router, carInfoManager: CarInfoManager(service: GlobalServiceLocator.shared.getService()))
        router.transitionHandler = view
        view.output = presenter
        presenter.moduleOutput = moduleOutput
        return navigationController
    }
}
