//
//  File 3.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import UIKit
import GlobalServiceLocator

enum PetrolsListAssembly {
    static func assembly() -> UIViewController {
        let viewController = PetrolsListViewController()
        let presenter = PetrolsListPresenter(view: viewController,
                                             petrolService: GlobalServiceLocator.shared.getService(),
                                             storage: GlobalServiceLocator.shared.getService())
        viewController.output = presenter
        return viewController
    }
}
