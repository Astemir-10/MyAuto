//
//  File.swift
//  Calculator
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import Foundation
import CombineCoreData
import Combine
import DesignKit

enum ExpensesScreenState {
    case loading, loaded(sections: [ExpenseModelProtocol]), error
}

protocol ExpensesViewInput: AnyObject {
    func setState(state: ExpensesScreenState)
}

protocol ExpensesViewOutput {
    func setup()
    func reload()
    func remove(item: ExpenseModelProtocol)
    func addExpense()
    func addExpense(type: ExpenseType)
    func analyticsExpense()
    func didSelectItem(item: ExpenseModelProtocol)
}

final class ExpensesPresenter: ExpensesViewOutput {
    
    weak var view: ExpensesViewInput?
    private let storage: CombineCoreData
    private let router: ExpensesRouterInput
    private var items: [ExpenseModelProtocol] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(storage: CombineCoreData, view: ExpensesViewInput, router: ExpensesRouterInput) {
        self.view = view
        self.router = router
        self.storage = storage
    }
    
    func addExpense() {
        router.openAddExpense(expenseType: .service)
    }
    
    func analyticsExpense() {
        router.openExpenseAnalytics()
    }
    
    func didSelectItem(item: any ExpenseModelProtocol) {
        
    }
    
    func addExpense(type: ExpenseType) {
        self.router.openAddExpense(expenseType: type)
    }
    
    func setup() {
        storage.fetchEntities(entity: Expense.self)
            .sink(receiveError: { error in
                print(error)
                print("Error")
            }, receiveValue: { [weak self] expenses in
                
                self?.handleExpenses(expenses: expenses)
            })
            .store(in: &cancellables)
    }
    
    func reload() {
        storage.fetchEntities(entity: Expense.self)
            .sink(receiveError: { error in
                print(error)
                print("Error")
            }, receiveValue: { [weak self] expenses in
                
                self?.handleExpenses(expenses: expenses)
            })
            .store(in: &cancellables)
    }
    
    private func handleExpenses(expenses: [Expense]) {
        items.removeAll()
        expenses.forEach({ expense in
            guard let expenseType = ExpenseType(rawValue: expense.expenseType) else { return }
            
            switch expenseType {
                
            case .petrol:
                if let expenseInfo = expense.expenseInfo,
                   let json = try? JSONSerialization.jsonObject(with: expenseInfo) as? [String: Any],
                   let liters = json["liters"] as? Double {
                    self.items.append(PetrolExpense(id: expense.id.uuidString,
                                                    date: expense.date,
                                                    sum: expense.sum,
                                                    type: expenseType,
                                                    description: expense.expenseDescription,
                                                    liters: liters,
                                                    petrolStation: json))
                }
            case .service:
                if let expenseInfo = expense.expenseInfo,
                   let json = try? JSONSerialization.jsonObject(with: expenseInfo) as? [[String: Any]] {
                    self.items.append(AutoserviceExpense(id: expense.id.uuidString,
                                                         date: expense.date,
                                                         sum: expense.sum, type: expenseType,
                                                         description: expense.expenseDescription,
                                                         service: json))
                }
            case .wash, .insurance, .taxes, .parking, .fines:
                self.items.append(CommonExpense(id: expense.id.uuidString,
                                                date: expense.date,
                                                sum: expense.sum,
                                                type: expenseType,
                                                description: expense.expenseDescription))
            }
        })
        self.view?.setState(state: .loaded(sections: items))
    }
    
    func remove(item: ExpenseModelProtocol) {
        storage.removeIfFind(entity: Expense.self, predicate: NSPredicate(format: "id == %@", item.id))
        self.items.removeAll(where: { $0.id == item.id })
    }
}
