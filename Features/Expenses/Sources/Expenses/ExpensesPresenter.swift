//
//  File.swift
//  Calculator
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import Foundation

protocol ExpensesViewInput: AnyObject {
    
}

protocol ExpensesViewOutput {
    
}

final class ExpensesPresenter: ExpensesViewOutput {
    
    weak var view: ExpensesViewInput?
    private let router: ExpensesRouterInput
    
    init(view: ExpensesViewInput, router: ExpensesRouterInput) {
        self.view = view
        self.router = router
    }
}
