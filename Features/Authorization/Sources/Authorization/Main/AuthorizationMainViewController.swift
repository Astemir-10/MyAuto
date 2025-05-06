//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit
import DesignKit

final class AuthorizationMainViewController: CommonViewController {
    
    var output: AuthorizationMainViewOutput!
    
    private lazy var titleLabel = UILabel().forAutoLayout()
    private lazy var loginTextField = TextField().forAutoLayout()
    private lazy var passwordTextField = TextField().forAutoLayout()
    private lazy var loginButton = Button().forAutoLayout()
    private lazy var registerButton = Button().forAutoLayout()
    private lazy var mainStackView = UIStackView().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        mainStackView.addConstraintToSuperView([.top(40), .leading(20), .trailing(-20)], withSafeArea: true)
        titleLabel.font = .appFonts.largeMedium
        titleLabel.textColor = .appColors.text.primary
        
        titleLabel.text = "Авторизация"
        titleLabel.textAlignment = .center
        loginTextField.setSize(height: 40)
        loginTextField.backgroundColor = .appColors.ui.primaryAlternative
        passwordTextField.setSize(height: 40)
        passwordTextField.backgroundColor = .appColors.ui.primaryAlternative
        
        loginTextField.placeholder = "Логин"
        passwordTextField.placeholder = "Пароль"
        
        loginButton.setSize(.medium)
        loginButton.primaryText = "Войти"
        
        registerButton.setSize(.small)
        registerButton.primaryText = "Зарегистрироваться"
        registerButton.setBackgroundStyle(.empty)
        
        mainStackView.addArrangedSubviews(titleLabel, loginTextField, passwordTextField, loginButton, registerButton)
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        
        loginButton.addAction(.init(handler: { [weak self] _ in
            self?.view.endEditing(true)
            self?.output?.didTapLogin(login: self?.loginTextField.text, password: self?.passwordTextField.text)
        }), for: .touchUpInside)
        
        registerButton.addAction(.init(handler: { [weak self] _ in
            self?.view.endEditing(true)
            self?.output.didTapRegistration()
        }), for: .touchUpInside)
    }
}


extension AuthorizationMainViewController: AuthorizationMainViewInput {
    
}
