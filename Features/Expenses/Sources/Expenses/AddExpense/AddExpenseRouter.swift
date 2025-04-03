//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import Architecture

protocol AddExpenseRouterInput: RouterInput {
    func openPetrolList()
}

final class AddExpenseRouter: AddExpenseRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    init(transitionHandler: TransitionHandler!) {
        self.transitionHandler = transitionHandler
    }
    
    func openPetrolList() {
        let vc = PetrolsListAssembly.assembly()
        transitionHandler.push(vc)
    }
}
