//
//  SearchViewController.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit

public final class SearchViewController: SheetViewController, UITextFieldDelegate {
    private lazy var searchTextField: TextField = {
        let textField = TextField().forAutoLayout()
        textField.delegate = self
        textField.placeholder = "Введите запрос"
        textField.backgroundColor = .appColors.ui.primaryAlternative
        return textField
    }()
    
    private let buttonsContainer: ButtonsContainer = {
        let buttonsContainer = ButtonsContainer().forAutoLayout()
        buttonsContainer.setTitles(primary: "Найти")
        return buttonsContainer
    }()
        
    var output: SearchViewOutput!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appColors.ui.mainSecondary
        
        // Добавьте текстовое поле и кнопку на экран
        view.addSubview(searchTextField)
        view.addSubview(buttonsContainer)
        
        setupLayout()
    }
    
    private func setupLayout() {
        buttonsContainer.addConstraintToSuperView([.leading(0), .trailing(0), .bottom(0)], withSafeArea: true)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: GraberView.Constants.height + 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        output.didBeginEditing()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
}

extension SearchViewController: SearchViewInput {
    func becomeFirstResponder() {
        searchTextField.becomeFirstResponder()
    }
    
}
