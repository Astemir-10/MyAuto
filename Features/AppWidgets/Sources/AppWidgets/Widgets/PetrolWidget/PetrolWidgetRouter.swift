//
//  File.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 13.11.2024.
//

import Architecture
import AppMap
import MapKit
import CoreLocation

protocol PetrolWidgetRouter: RouterInput {
    func navigateToMap(annotations: [PetrolAnnotation], current: PetrolAnnotation)
}

final class PetrolWidgetRouterImpl: PetrolWidgetRouter {
    weak var transitionHandler: TransitionHandler!
    
    func navigateToMap(annotations: [PetrolAnnotation], current: PetrolAnnotation) {
        let appMapViewController = AppMapAssmebly.assembly(annotations: annotations, current: current)
        transitionHandler.push(appMapViewController)
    }
    

}
