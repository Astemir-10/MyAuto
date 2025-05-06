//
//  File 3.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit

enum AddCarAssembly {
    func assembly() -> UIViewController {
        let view = AddCarViewController()
        let presenter = AddCarPresenter(view: view)
        view.output = presenter
        return view
    }
}
