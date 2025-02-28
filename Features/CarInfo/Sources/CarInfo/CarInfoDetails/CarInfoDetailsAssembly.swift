//
//  CarInfoDetailsAssembly.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit
import AppServices
import GlobalServiceLocator

enum CarInfoDetailsAssembly {
    static func makeModule(carData: CarInfoModel.CarData?, carNumber: String?) -> UIViewController {
        let view = CarInfoDetailsViewController()
        let presenter = CarInfoDetailsPresenter(carData: carData, carNumber: carNumber, view: view, coreDataService: GlobalServiceLocator.shared.getService())
        view.output = presenter
        return view
    }
}
