//
//  WeatherWidgetAssembly.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import UIKit
import LocationManager
import GlobalServiceLocator

public enum WeatherWidgetAssembly {
    public static func assembly(widgetOutput: WidgetOutput? = nil) -> (UIViewController, WidgetInput) {
        let view = WeatherWidgetView()
        let presenter = WeatherWidgetPresenter(locationManager: LocationManagerImpl(),
                                               weatherService: GlobalServiceLocator.shared.getService(),
                                               widgetOutput: widgetOutput,
                                               view: view)
        view.output = presenter
        return (view, presenter)
    }
}
