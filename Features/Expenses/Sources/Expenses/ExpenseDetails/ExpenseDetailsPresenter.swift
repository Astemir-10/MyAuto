//
//  File 2.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import Foundation

protocol ExpenseDetailsViewInput: AnyObject {
    
}

protocol ExpenseDetailsViewOutput {
    
}

final class ExpenseDetailsPresenter: ExpenseDetailsViewOutput {
    private weak var view: ExpenseDetailsViewInput?
    
    init(view: ExpenseDetailsViewInput) {
        self.view = view
    }
    
}
