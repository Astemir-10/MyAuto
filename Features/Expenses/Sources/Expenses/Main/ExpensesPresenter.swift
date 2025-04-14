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
import ReceiptReader

enum ExpensesScreenState {
    case loading, loaded(sections: [ExpenseModelProtocol]), error
}

protocol ExpensesViewInput: AnyObject {
    func setState(state: ExpensesScreenState)
}

protocol ExpensesViewOutput {
    func selectedFilter() -> ExpenseFilter
    func setup()
    func reload()
    func updateState()
    func remove(item: ExpenseModelProtocol)
    func addExpense()
    func addExpense(type: ExpenseType)
    func analyticsExpense()
    func didSelectItem(item: ExpenseModelProtocol)
    func getStartDate() -> Date?
    func getEndDate() -> Date?
    func getTotalAmount() -> Double
    func setSelectedFilter(filter: ExpenseFilter)
}

final class ExpensesPresenter: ExpensesViewOutput {
    
    weak var view: ExpensesViewInput?
    private let storage: CombineCoreData
    private let router: ExpensesRouterInput
    private var items: [ExpenseModelProtocol] = []
    private var cancellables = Set<AnyCancellable>()
    private var currentFilter: ExpenseFilter = .today
    
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
        if case .qrCode = type {
            self.router.openReceiptReader(output: self)
        } else {
            self.router.openAddExpense(expenseType: type)
        }
    }
    
    func getTotalAmount() -> Double {
        var totalAmount = 0.0
        self.itemsWithFilter().forEach({ totalAmount += $0.sum })
        return totalAmount
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
    
    func updateState() {
        self.view?.setState(state: .loaded(sections: self.items))
    }
    
    func selectedFilter() -> ExpenseFilter {
        self.currentFilter
    }
    
    func setSelectedFilter(filter: ExpenseFilter) {
        guard currentFilter != filter else { return }
        currentFilter = filter
        self.view?.setState(state: .loaded(sections: itemsWithFilter()))
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
            case .qrCode:
                break
            }
        })
        self.view?.setState(state: .loaded(sections: itemsWithFilter() ))
    }
    
    func remove(item: ExpenseModelProtocol) {
        storage.removeIfFind(entity: Expense.self, predicate: NSPredicate(format: "id == %@", item.id))
        self.items.removeAll(where: { $0.id == item.id })
    }
    
    private func itemsWithFilter() -> [ExpenseModelProtocol] {
        let calendar = Calendar.current
        let now = Date()
//        items.append(CommonExpense(id: "123", date: "22.01.2025".toDate(dateForamtter: .simpleFormatter)!, sum: 3413, type: .insurance))
//        items.append(CommonExpense(id: "1623", date: "22.02.2025".toDate(dateForamtter: .simpleFormatter)!, sum: 232, type: .petrol))
//        items.append(CommonExpense(id: "1243", date: "22.03.2025".toDate(dateForamtter: .simpleFormatter)!, sum: 65, type: .insurance))
//        items.append(CommonExpense(id: "1253", date: "22.12.2024".toDate(dateForamtter: .simpleFormatter)!, sum: 645, type: .parking))
//        items.append(CommonExpense(id: "1237", date: "22.01.2025".toDate(dateForamtter: .simpleFormatter)!, sum: 43, type: .taxes))
        
        return items.filter { item in
            switch currentFilter {
            case .all:
                return true
            case .today:
                return calendar.isDate(item.date, inSameDayAs: now)
            case .month:
                return calendar.isDate(item.date, equalTo: now, toGranularity: .month)
            case .year:
                return calendar.isDate(item.date, equalTo: now, toGranularity: .year)
            case .yesterday:
                let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
                return calendar.isDate(item.date, inSameDayAs: yesterday)
            case .week:
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
                let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
                return item.date >= startOfWeek && item.date <= endOfWeek
            }
        }.sorted(by: { $0.date > $1.date })
    }
    
    func getStartDate() -> Date? {
        itemsWithFilter().last?.date
    }
    
    func getEndDate() -> Date? {
        itemsWithFilter().first?.date
    }
}

extension ExpensesPresenter: ReceiptReaderDelegate {
    func didReadReceipt(with result: Result<String, ReceiptReader.ReceiptError>) {
        switch result {
        case .success(let receiptData):
            print(receiptData)
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
