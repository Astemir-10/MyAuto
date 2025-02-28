//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import Architecture
import Foundation


protocol MainRouterInput: RouterInput {
}

final class MainRouter: MainRouterInput {
    weak var transitionHandler: TransitionHandler!
    

}
