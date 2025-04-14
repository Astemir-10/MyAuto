//
//  File.swift
//  Calculator
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import Foundation
import Architecture
import ReceiptReader

protocol ExpensesRouterInput: RouterInput {
    func openAddExpense(expenseType: ExpenseType)
    func openExpenseAnalytics()
    func openReceiptReader(output: ReceiptReaderDelegate)
    func openExpenseDetails(expenseModel: ExpenseModelProtocol)
}

final class ExpensesRouter: ExpensesRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    func openAddExpense(expenseType: ExpenseType) {
        let viewController = AddExpenseAssembly.assembly(expenseType: expenseType)
        transitionHandler.push(viewController)
    }
    
    func openExpenseAnalytics() {
        let viewController = ExpenseAnalyticsAssembly.assembly()
        transitionHandler.push(viewController)
    }
    
    func openExpenseDetails(expenseModel: ExpenseModelProtocol) {
        let viewController = ExpenseDetailsAssembly.assembly(expenseModel: expenseModel)
        transitionHandler.push(viewController)
    }
    
    func openReceiptReader(output: ReceiptReaderDelegate) {
        let vc = ReceiptReaderViewController()
        vc.delegate = output
        vc.withCancelButton = true
        vc.needDissmisAfterRead = true
        vc.modalPresentationStyle = .fullScreen
        transitionHandler.present(vc)
    }
}
