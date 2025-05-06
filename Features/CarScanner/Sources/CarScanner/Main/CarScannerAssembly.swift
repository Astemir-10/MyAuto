//
//  File 3.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import UIKit
import CarScannerCore
import DesignKit

public enum CarScannerAssembly {
    public static func assembly() -> UIViewController {
        let vc = CarScannerViewController()
        let router = CarScannerRouter()
        router.transitionHandler = vc
        let presenter = CarScannerPresenter(view: vc, router: router)
        vc.output = presenter
        return vc
    }
    
    public static func assemblyWithNavigation() -> UIViewController {
        let vc = CarScannerViewController()
        let router = CarScannerRouter()
        router.transitionHandler = vc
        let presenter = CarScannerPresenter(view: vc, router: router)
        vc.output = presenter
        return AppNavigationController(rootViewController: vc)
    }
}
