//
//  File.swift
//  Calculator
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import Foundation
import Architecture

protocol CalculatorRouterInput: RouterInput {
    
}

final class CalculatorRouter: CalculatorRouterInput {
    weak var transitionHandler: TransitionHandler!
    
    
}
