//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import Foundation

protocol ConfirmationViewInput: AnyObject {
    
}

protocol ConfirmationViewOutput {
    func confirm(code: String)
    func resend()
}

final class ConfirmationPresenter: ConfirmationViewOutput {
    
    private weak var view: ConfirmationViewInput?
    private weak var moduleOutput: ConfirmationModuleOutput?
    
    init(moduleOutput: ConfirmationModuleOutput? = nil, view: ConfirmationViewInput) {
        self.view = view
        self.moduleOutput = moduleOutput
    }
    
    
    func confirm(code: String) {
        moduleOutput?.confirm(code: code)
    }
    
    func resend() {
        moduleOutput?.resend()
    }
}
