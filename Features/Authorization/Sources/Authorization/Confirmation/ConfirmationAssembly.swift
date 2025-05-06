//
//  File 2.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit

protocol ConfirmationModuleOutput: AnyObject {
    func confirm(code: String)
    func resend()
}

enum ConfirmationState {
    case loading, succes, failed
}

protocol ConfirmationModuleInput: AnyObject {
    func setState(state: ConfirmationState)
}

enum ConfirmationAssembly {
    static func assembly(moduleOutput: ConfirmationModuleOutput, moduleInputBuilder: (ConfirmationModuleInput) -> ()) -> UIViewController {
        let view = ConfirmationViewController()
        moduleInputBuilder(view)
        let presenter = ConfirmationPresenter(moduleOutput: moduleOutput, view: view)
        view.output = presenter
        return view
    }

}
