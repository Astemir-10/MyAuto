//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit

public protocol SearchModuleOutput: AnyObject {
    func searchBeginEditing()
}

public protocol SearchModuleInput: AnyObject {
    func becomeFirstResponder()
}

public enum SearchAssembly {
    public static func assembly(moduleOutput: SearchModuleOutput) -> (UIViewController, SearchModuleInput)  {
        let view = SearchViewController()
        
        let presenter = SearchPresenter(view: view)
        presenter.moduleOutput = moduleOutput
        view.output = presenter
        return (view, presenter)
    }
    
    public static func assembly(moduleOutput: SearchModuleOutput) -> UIViewController  {
        let view = SearchViewController()
        
        let presenter = SearchPresenter(view: view)
        presenter.moduleOutput = moduleOutput
        view.output = presenter
        return view
    }
}
