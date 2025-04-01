//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit

enum ExpenseAnalyticsAssembly {
    static func assembly() -> UIViewController {
        let viewController = ExpenseAnalyticsViewController()
        let presenter = ExpenseAnalyticsPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
