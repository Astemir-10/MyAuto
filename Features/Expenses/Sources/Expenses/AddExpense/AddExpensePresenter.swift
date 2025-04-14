//
//  File 2.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import Foundation
import CombineCoreData
import Combine

protocol AddExpenseViewInput: AnyObject {
    func setState(expenseType: ExpenseType)
}

protocol AddExpenseViewOutput {
    var expenseType: ExpenseType { get }
    func setup()
    func saveExpense(model: ExpenseModelProtocol)
    func selectPetrol()
}

final class AddExpensePresenter: AddExpenseViewOutput {
    private weak var view: AddExpenseViewInput?
    internal let expenseType: ExpenseType
    private let storage: CombineCoreData
    private var cancellables = Set<AnyCancellable>()
    private let router: AddExpenseRouterInput
    
    init(storage: CombineCoreData, expenseType: ExpenseType, view: AddExpenseViewInput, router: AddExpenseRouterInput) {
        self.view = view
        self.expenseType = expenseType
        self.storage = storage
        self.router = router
    }
    
    func setup() {
        view?.setState(expenseType: expenseType)
    }
    
    func saveExpense(model: ExpenseModelProtocol) {
        switch expenseType {
        case .petrol:
            if let model = model as? PetrolExpense {
                storage.createEntity(entity: Expense.self) { object in
                    object.id = .init(uuidString: model.id) ?? UUID()
                    object.date = model.date
                    object.expenseDescription = model.description
                    object.expenseType = self.expenseType.rawValue
                    object.sum = model.sum
                    var dictionary = model.petrolStation.toDictionary()
                    dictionary["liters"] = model.liters
                    object.expenseInfo = dictionary.toJsonData()
                }
                .sink(receiveError: { error in
                    print(error)
                })
                .store(in: &self.cancellables)
            }
        case .service:
            if let model = model as? AutoserviceExpense {
                storage.createEntity(entity: Expense.self) { object in
                    object.id = .init(uuidString: model.id) ?? UUID()
                    object.date = model.date
                    object.expenseDescription = model.description
                    object.expenseType = self.expenseType.rawValue
                    object.sum = model.sum
                    object.expenseInfo = model.services.map({ $0.toDictionary() }).toJsonData()
                }
                .sink(receiveError: { error in
                    print(error)
                })
                .store(in: &self.cancellables)
            }
        case .wash, .fines, .insurance, .taxes, .parking:
            if let model = model as? CommonExpense {
                storage.createEntity(entity: Expense.self) { object in
                    object.id = .init(uuidString: model.id) ?? UUID()
                    object.date = model.date
                    object.expenseDescription = model.description
                    object.expenseType = self.expenseType.rawValue
                    object.sum = model.sum
                    object.expenseInfo = nil
                }
                .sink(receiveError: { error in
                    print(error)
                })
                .store(in: &self.cancellables)
            }
        case .qrCode:
            break
        }
    }
    
    func selectPetrol() {
        router.openPetrolList()
    }
}
