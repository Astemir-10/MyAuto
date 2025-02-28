//
//  File.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import UIKit

public enum BannerWidgetAssembly {
    public static func assembly(state: BannerWidgetState) -> UIViewController {
        let view = BannerWidgetView()
        let presenter = BannerWidgetPresenter(state: state, view: view)
        view.output = presenter
        return view
    }
}
