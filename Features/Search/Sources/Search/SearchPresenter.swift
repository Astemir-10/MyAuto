//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import Foundation

protocol SearchViewInput: AnyObject {
    func becomeFirstResponder()
}

protocol SearchViewOutput {
    func didBeginEditing()
}

final class SearchPresenter {
    weak var view: SearchViewInput?
    weak var moduleOutput: SearchModuleOutput?
    
    init(view: SearchViewInput) {
        self.view = view
    }
}

extension SearchPresenter: SearchViewOutput {
    func didBeginEditing() {
        moduleOutput?.searchBeginEditing()
    }
}

extension SearchPresenter: SearchModuleInput {
    func becomeFirstResponder() {
        view?.becomeFirstResponder()
    }
    
}
