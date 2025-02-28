//
//  NewsAssmebly.swift
//  AppMap
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import DesignKit
import UIKit

public enum NewsAssmebly {
    public static func assembly() -> UIViewController {
        let newsViewController = NewsViewController()
        let navigation = AppNavigationController(rootViewController: newsViewController)
        return navigation
    }
}
