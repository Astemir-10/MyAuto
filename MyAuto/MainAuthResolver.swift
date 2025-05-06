//
//  File.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit
import AppKeychain
import Authorization
import DesignKit

enum MainAuthResolver {
    static func getViewController() -> UIViewController {
        let appkeychain = AppKeychainImpl(service: "com.myauto.MyAuto")
        if appkeychain.get(by: "refreshToken") == nil {
            return AppNavigationController(rootViewController: AuthorizationMainAssembly.assembly())
        } else {
            return MainTabBarViewController()
        }
    }
}
