//
//  File 3.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit

enum ExpenseDetailsAssembly {
    static func assembly(expenseModel: ExpenseModelProtocol) -> UIViewController {
        let viewController = ExpenseDetailsViewController()
        let presenter = ExpenseDetailsPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}

