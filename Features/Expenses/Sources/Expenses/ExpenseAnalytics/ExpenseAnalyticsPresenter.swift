//
//  File 3.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import Foundation

protocol ExpenseAnalyticsViewInput: AnyObject {
    
}

protocol ExpenseAnalyticsViewOutput {
    
}

final class ExpenseAnalyticsPresenter: ExpenseAnalyticsViewOutput {
    private weak var view: ExpenseAnalyticsViewInput?
    
    init(view: ExpenseAnalyticsViewInput) {
        self.view = view
    }
    
}
