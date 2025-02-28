//
//  File.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 03.11.2024.
//

import Foundation
import UIKit
import GlobalServiceLocator
import LocationManager
import Architecture

public protocol PetrolWidgetModuleOutput: AnyObject, WidgetOutput {
    func didTapLocation(item: PetrolWidgetInfoModel)
    func didTapPetrol(item: PetrolWidgetInfoModel)
}

public enum PetrolWidgetAssembly {
    public static func assembly(moduleOutput: PetrolWidgetModuleOutput, transitionHandler: TransitionHandler) -> UIViewController {
        let view = PetrolWidgetView()
        let router = PetrolWidgetRouterImpl()
        router.transitionHandler = transitionHandler
        let presenter = PetrolWidgetPresenter(petrolService: GlobalServiceLocator.shared.getService(),
                                              geocoderService: GlobalServiceLocator.shared.getService(),
                                              widgetOutput: moduleOutput,
                                              locationManager: LocationManagerImpl(),
                                              view: view,
                                              moduleOutput: moduleOutput,
                                              router: router)
        view.output = presenter
        return view
    }
}
