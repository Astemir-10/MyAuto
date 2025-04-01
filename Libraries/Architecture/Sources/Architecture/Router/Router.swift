//
//  Router.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit
import Extensions

public protocol TransitionHandler: AnyObject {
    func present(_ viewController: UIViewController)
    func push(_ viewController: UIViewController)
    func close()
    func pop()
    func closeTopViewController()
}

public protocol RouterInput {
    var transitionHandler: TransitionHandler! { get set }
    func close()
    func closeTopViewController()
}

public extension RouterInput {
    func close() {
        transitionHandler.close()
    }
    
    func closeTopViewController() {
        transitionHandler.closeTopViewController()
    }
}

extension UIViewController: TransitionHandler {
    public func present(_ viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
    
    public func push(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func close() {
        self.dismiss(animated: true)
    }
    
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    public func closeTopViewController() {
        self.topViewController?.dismiss(animated: true)
    }

}
