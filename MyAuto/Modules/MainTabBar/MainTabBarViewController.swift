//
//  MainTabBarViewController.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import CarInfo
import MainScreen
import Profile
import Search
import News
import Calculator
import Expenses
import DesignTokens
import Documents

final class MainTabBarViewController: UITabBarController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupTabBar()
        }
        
        private func setupTabBar() {
            let homeVC = MainAssembly.assembly()
            homeVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage.appImages.sfIcons.home.icon, tag: 0)
            
            let documentsVC = DocumentsAssembly.assembly()
            documentsVC.tabBarItem = UITabBarItem(title: "Документы", image: UIImage.appImages.sfIcons.document.icon, tag: 1)
            
            let expensesVC = ExpensesAssembly.assembly()
            expensesVC.tabBarItem = UITabBarItem(title: "Расходы", image: UIImage.appImages.sfIcons.dollar.icon, tag: 2)
            
            let profileVC = ProfileAssmebly.assembly()
            profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage.appImages.sfIcons.user.icon, tag: 3)
            
            viewControllers = [homeVC, documentsVC, expensesVC, profileVC]
            
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.appColors.ui.tabBar.background // Цвет самого таббара
            
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.normal.iconColor = UIColor.appColors.ui.tabBar.tabNormal // Цвет неактивных иконок
            tabBarItemAppearance.selected.iconColor = UIColor.appColors.ui.tabBar.tabSelected // Цвет активных иконок
            
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appColors.ui.tabBar.tabNormal]
            tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appColors.ui.tabBar.tabSelected]
            
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            
            tabBar.tintColor = UIColor(hex: "customIconColorActive")
            tabBar.unselectedItemTintColor = UIColor(hex: "customIconColorInactive")

        }

}
