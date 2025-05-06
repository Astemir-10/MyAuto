//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import Foundation
import AppServices
import Combine
import AppKeychain
import UserDefaultsExtensions

protocol AuthorizationMainViewInput: AnyObject {
    
}

protocol AuthorizationMainViewOutput {
    func didTapRegistration()
    func didTapLogin(login: String?, password: String?)
}

final class AuthorizationMainPresenter: AuthorizationMainViewOutput {
    
    private weak var view: AuthorizationMainViewInput?
    private let router: AuthorizationMainRouterInput
    private let authService: AuthorizationService
    private let keychain: AppKeychain
    private var cancellables = Set<AnyCancellable>()
    
    init(keychain: AppKeychain, authService: AuthorizationService, router: AuthorizationMainRouterInput, view: AuthorizationMainViewInput) {
        self.authService = authService
        self.view = view
        self.router = router
        self.keychain = keychain
    }
    
    func didTapRegistration() {
        router.openRegisterScreen()
    }
    
    func didTapLogin(login: String?, password: String?) {
        guard let login = validate(login: login), let password = validate(password: password) else {
            return
        }
        authService.login(loginModel: .init(login: login,
                                            password: password))
        .sink(receiveError: { error in
            print("ERROR LOGIN", error.localizedDescription)
        }, receiveValue: { [weak self] value in
            guard let self else {
                return
            }
            UserDefaults.appDefaults.set(name: .userId, string: value.userId)
            self.keychain.set(value.accessToken, by: "accessToken")
            self.keychain.set(value.refreshToken, by: "refreshToken")
            NotificationCenter.default.post(name: .init("updateAuth"), object: nil)
        })
        .store(in: &cancellables)
    }
    
    private func validate(login: String?) -> String? {
        return login
    }
    
    private func validate(password: String?) -> String? {
        return password
    }
}
