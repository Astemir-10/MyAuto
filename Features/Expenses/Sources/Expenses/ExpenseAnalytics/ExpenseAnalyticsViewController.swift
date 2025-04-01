//
//  File 2.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit
import DesignKit
import DesignTokens

final class ExpenseAnalyticsViewController: CommonViewController {
    var output: ExpenseAnalyticsViewOutput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Аналитика"
    }
    
}

extension ExpenseAnalyticsViewController: ExpenseAnalyticsViewInput {
    
}
