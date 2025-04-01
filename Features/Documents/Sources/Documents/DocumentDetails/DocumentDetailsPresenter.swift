//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 14.03.2025.
//

import Foundation

protocol DocumentDetailsViewInput: AnyObject {
    
    
}

protocol DocumentDetailsViewOutput {
    func viewDidLoad()
}

final class DocumentDetailsPresenter {
    weak var view: DocumentDetailsViewInput?
    
    private let documentId: String
    
    init(documentId: String, view: DocumentDetailsViewInput) {
        self.view = view
        self.documentId = documentId
    }
}


extension DocumentDetailsPresenter: DocumentDetailsViewOutput {
    func viewDidLoad() {
        
    }
}
