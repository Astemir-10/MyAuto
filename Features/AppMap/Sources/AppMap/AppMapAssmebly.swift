//
//  AppMapAssmebly.swift
//  AppMap
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import DesignKit
import GlobalServiceLocator
import MapKit
import CoreLocation

public enum AppMapAssmebly {
    public static func assembly(annotations: [PetrolAnnotation], current: PetrolAnnotation) -> UIViewController {
        let viewController = AppMapViewController()
        viewController.annotations = annotations
        viewController.currentAnnotation = current
        return viewController
    }
}
