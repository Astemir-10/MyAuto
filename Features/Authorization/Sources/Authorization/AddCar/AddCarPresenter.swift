//
//  File 2.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import Foundation

protocol AddCarViewInput: AnyObject {
    
}

protocol AddCarViewOutput {
    
}

final class AddCarPresenter: AddCarViewOutput {
    private weak var view: AddCarViewInput?
    
    init(view: AddCarViewInput) {
        self.view = view
    }
}
