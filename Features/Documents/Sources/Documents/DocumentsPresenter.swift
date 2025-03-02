//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import Foundation

protocol DocumentsViewInput: AnyObject {
    
}

protocol DocumentsViewOutput {
    
}

final class DocumentsPresenter: DocumentsViewOutput {
    
    weak var view: DocumentsViewInput?
    private let router: DocumentsRouterInput
    
    init(view: DocumentsViewInput, router: DocumentsRouterInput) {
        self.view = view
        self.router = router
    }
}
