//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit
import DesignKit

final class RegistrationViewController: CommonViewController {
    
    var output: RegistrationViewOutput!
    
    private lazy var titleLabel = UILabel().forAutoLayout()
    private lazy var loginTextField = TextField().forAutoLayout()
    private lazy var passwordTextField = TextField().forAutoLayout()
    private lazy var confirmPasswordTextField = TextField().forAutoLayout()
    private lazy var registerButton = Button().forAutoLayout()
    private lazy var mainStackView = UIStackView().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        mainStackView.addConstraintToSuperView([.top(40), .leading(20), .trailing(-20)], withSafeArea: true)
        titleLabel.font = .appFonts.largeMedium
        titleLabel.textColor = .appColors.text.primary
        
        titleLabel.text = "Регистрация"
        titleLabel.textAlignment = .center
        loginTextField.setSize(height: 40)
        loginTextField.backgroundColor = .appColors.ui.primaryAlternative
        passwordTextField.setSize(height: 40)
        passwordTextField.backgroundColor = .appColors.ui.primaryAlternative
        
        loginTextField.placeholder = "Логин"
        passwordTextField.placeholder = "Пароль"
        
        confirmPasswordTextField.setSize(height: 40)
        confirmPasswordTextField.backgroundColor = .appColors.ui.primaryAlternative
        confirmPasswordTextField.placeholder = "Подтвердите пароль"

        
        registerButton.setSize(.medium)
        registerButton.primaryText = "Зарегистрироваться"
                
        mainStackView.addArrangedSubviews(titleLabel, loginTextField, passwordTextField, confirmPasswordTextField, registerButton)
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        
        registerButton.addAction(.init(handler: { [weak self] _ in
            self?.view.endEditing(true)
            self?.output.register(login: self?.loginTextField.text, password: self?.passwordTextField.text, confirmPassword: self?.confirmPasswordTextField.text)
        }), for: .touchUpInside)

    }
}

extension RegistrationViewController: RegistrationViewInput {
    
}
