//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 14.03.2025.
//

import UIKit

enum DocumentDetailsAssembly {
    static func assemble(documentId: String) -> UIViewController {
        let viewController = DocumentDetailsViewController()
        let presenter = DocumentDetailsPresenter(documentId: documentId, view: viewController)
        viewController.output = presenter
        return viewController
    }
}
