//
//  File 2.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import Foundation

protocol SearchResultsViewInput: AnyObject {
    func setExpandedState()
    func updateUI(items: [SearchResultItem])
}

protocol SearchResultsViewOutput {
    func viewDidLoad()
}


final class SearchResultsPresenter {
    weak var view: SearchResultsViewInput?
    
    init(view: SearchResultsViewInput) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.updateUI(items: [SearchResultModel.init(title: "Hello"), SearchResultModel.init(title: "LOLOL")])
    }
}

extension SearchResultsPresenter: SearchResultsViewOutput {
    
}

extension SearchResultsPresenter: SearchModuleOutput {
    func searchBeginEditing() {
        self.view?.setExpandedState()
    }
}
