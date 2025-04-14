//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import Architecture
import ReceiptReader

protocol AddExpenseRouterInput: RouterInput {
    func openPetrolList()
    func openReceiptReader(output: ReceiptReaderDelegate)
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
    
    func openReceiptReader(output: ReceiptReaderDelegate) {
        let vc = ReceiptReaderViewController()
        vc.delegate = output
        transitionHandler.push(vc)
    }
}
