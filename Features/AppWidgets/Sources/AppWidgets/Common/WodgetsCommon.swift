//
//  File.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 03.11.2024.
//

import Foundation

protocol WidgetViewInput: AnyObject {
    func setState(_ state: WidgetState)
}

public enum WidgetType: Int {
    case petrol, weather
}

public protocol WidgetOutput: AnyObject {
    func widgetIsLoaded(widgetType: WidgetType)
}


enum WidgetState {
    case error
    case loading
    case loaded(data: Any)
}
