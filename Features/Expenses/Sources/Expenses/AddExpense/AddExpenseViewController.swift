//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit
import DesignKit

final class AddExpenseViewController: CommonViewController {
    
    var output: AddExpenseViewOutput!
    
    private lazy var sumTextField: TextField = {
        let tf = TextField()
        tf.backgroundColor = .appColors.ui.primaryAlternativeThirdty
        tf.setSize(height: 40)
        tf.keyboardType = .numberPad
        return tf.forAutoLayout()
    }()
    
    private lazy var addButton: ButtonsContainer = {
        let buttonsContainer = ButtonsContainer()
        buttonsContainer.setTitles(primary: "Добавить")
        buttonsContainer.primaryTapHandler { [weak self] in
            guard let self else { return }
            if let sum = self.sumTextField.text, let double = Double(sum) {
                self.output.saveExpense(model: CommonExpense(id: UUID().uuidString, date: Date(), sum: double, type: output.expenseType))
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        return buttonsContainer.forAutoLayout()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.setup()
        self.view.addSubview(addButton)
        addButton.addConstraintToSuperView([.leading(0), .trailing(0), .bottom(-12)], withSafeArea: true)
        
        navigationItem.rightBarButtonItem = .init(title: "Готово", style: .done, target: self, action: #selector(doneAction))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sumTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    @objc
    private func doneAction() {
        view.endEditing(true)
    }
    
    private func buildFor(expenseType: ExpenseType) {
        title = expenseType.title
        
        switch expenseType {
        case .petrol:
            break
        case .service:
            break
        case .wash, .insurance, .taxes, .parking, .fines:
            self.view.addSubview(sumTextField)
            sumTextField.addConstraintToSuperView([.leading(20), .trailing(-20), .centerY(-100)])
        }
        
    }
}

extension AddExpenseViewController: AddExpenseViewInput {
    func setState(expenseType: ExpenseType) {
        buildFor(expenseType: expenseType)
    }
}
