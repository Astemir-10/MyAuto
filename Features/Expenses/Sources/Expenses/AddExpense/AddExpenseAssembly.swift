//
//  File 3.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit
import GlobalServiceLocator

enum AddExpenseAssembly {
    static func assembly(expenseType: ExpenseType) -> UIViewController {
        let viewController = AddExpenseViewController()
        let router = AddExpenseRouter(transitionHandler: viewController)
        let presenter = AddExpensePresenter(storage: GlobalServiceLocator.shared.getService(),
                                            expenseType: expenseType,
                                            view: viewController,
                                            router: router)
        viewController.output = presenter
        return viewController
    }
}
