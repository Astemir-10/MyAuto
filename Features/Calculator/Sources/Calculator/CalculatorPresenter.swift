//
//  File.swift
//  Calculator
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import Foundation

protocol CalculatorViewInput: AnyObject {
    
}

protocol CalculatorViewOutput {
    
}

final class CalculatorPresenter: CalculatorViewOutput {
    
    weak var view: CalculatorViewInput?
    private let router: CalculatorRouterInput
    
    init(view: CalculatorViewInput, router: CalculatorRouterInput) {
        self.view = view
        self.router = router
    }
}
