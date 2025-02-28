//
//  File 3.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit
import DesignKit

public enum SearchResultsAssembly {
    public static func assembly() -> UIViewController {
        let view = SearchResultsViewController()
        let navigation = AppNavigationController(rootViewController: view)
        let presenter = SearchResultsPresenter(view: view)
        view.output = presenter
        let search: UIViewController = SearchAssembly.assembly(moduleOutput: presenter)
        view.searchViewController = search
        return navigation
    }
}
