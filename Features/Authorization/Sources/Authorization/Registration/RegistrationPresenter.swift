//
//  File 2.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import Foundation
import AppServices
import Combine
import AppKeychain

protocol RegistrationViewInput: AnyObject {
    
}

protocol RegistrationViewOutput {
    func register(login: String?, password: String?, confirmPassword: String?)
    
}

final class RegistrationPresenter: RegistrationViewOutput {
    
    private weak var view: RegistrationViewInput?
    private weak var confirmationModuleInput: ConfirmationModuleInput?
    private let router: RegistrationRouterInput
    private let authService: AuthorizationService
    private let keychain: AppKeychain
    private var cancellable = Set<AnyCancellable>()
    private var registerUserId: String?
    
    init(keychain: AppKeychain, authService: AuthorizationService, router: RegistrationRouterInput, view: RegistrationViewInput) {
        self.view = view
        self.router = router
        self.keychain = keychain
        self.authService = authService
    }
    
    func register(login: String?, password: String?, confirmPassword: String?) {
        guard let login, let password, let confirmPassword else {
            return
        }
        if password != confirmPassword {
            return
        }
        authService
            .registration(registrationModel: .init(login: login, password: password, loginType: "phone"))
            .sink(receiveError: { error in
                
            }, receiveValue: { [weak self] user in
                guard let self else { return }
                UserDefaults.appDefaults.set(name: .userId, string: String(user.userId))
                self.registerUserId = String(user.userId)
                self.router.confirm(output: self, moduleInput: { module in
                    self.confirmationModuleInput = module
                })
            })
            .store(in: &cancellable)
    }
}

extension RegistrationPresenter: ConfirmationModuleOutput {
    func confirm(code: String) {
        guard let registerUserId else {
            return
        }
        authService.confirmationCode(confirmModel: .init(userId: registerUserId,
                                                         code: code))
        .sink(receiveError: { [weak self] _ in
            self?.confirmationModuleInput?.setState(state: .failed)
        }, receiveValue: { [weak self] token in
            guard let self else {
                return
            }
            
            self.confirmationModuleInput?.setState(state: .succes)
            self.keychain.set(token.accessToken, by: "accessToken")
            self.keychain.set(token.refreshToken, by: "refreshToken")
            NotificationCenter.default.post(name: .init("updateAuth"), object: nil)
        })
        .store(in: &cancellable)
    }
    
    func resend() {
        
    }
}
