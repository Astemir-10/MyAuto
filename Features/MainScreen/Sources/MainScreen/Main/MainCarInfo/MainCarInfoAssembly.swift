//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 01.03.2025.
//

import UIKit

public enum MainCarInfoAssembly {
    public static func assembly() -> UIViewController {
        let vc = MainCarInfoViewController()
        let presenter = MainCarInfoPresenter(view: vc)
        vc.output = presenter
        return vc
    }
}
