//
//  File.swift
//  Services
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import UIKit
import GlobalServiceLocator

public enum CheckFinesAssembly {
    public static func assembly(mode: CheckFinesMode) -> UIViewController {
        let vc = CheckFinesViewController()
        let presenter = CheckFinesPresenter(checkService: GlobalServiceLocator.shared.getService(), mode: mode, view: vc)
        vc.output = presenter
        return vc
    }
}
