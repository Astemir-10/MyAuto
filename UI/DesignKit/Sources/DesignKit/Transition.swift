//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit

public enum AppTransition {
    public static func makePushTransition(view: UIView) -> CATransition {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        return transition
    }
    
    public static func makePopTransition(view: UIView) -> CATransition {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0
        }
        return transition
    }
    
    public static func presentTransition(view: UIView, animation: (() -> ())? = nil) {
        view.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            view.transform = .identity
            view.alpha = 1
            animation?()
        } completion: { _ in
            
        }

    }
    
    public static func dismissTransition(view: UIView, animation: (() -> ())? = nil, completion: (() -> ())?) {
        
        UIView.animate(withDuration: 0.3) {
            view.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
            view.alpha = 0
            animation?()
        } completion: { _ in
            completion?()
        }
    }
}
