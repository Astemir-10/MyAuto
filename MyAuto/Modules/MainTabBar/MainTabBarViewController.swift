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

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profile = ProfileAssmebly.assembly()
        let main = MainAssembly.assembly()
        let search = SearchResultsAssembly.assembly()
        let news = NewsAssmebly.assembly()
        
        main.tabBarItem = .init(title: "Main", image: nil, tag: 0)
        search.tabBarItem = .init(title: "Search", image: nil, tag: 1)
        news.tabBarItem = .init(title: "News", image: nil, tag: 2)
        profile.tabBarItem = .init(title: "Profile", image: nil, tag: 3)
        
        viewControllers = [main, search, news, profile]
        
    }
}
