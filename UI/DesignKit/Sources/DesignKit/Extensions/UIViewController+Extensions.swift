//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import UIKit

public extension UIViewController {
    func removeFromParentVC() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func addChildVC(_ vc: UIViewController) {
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        vc.didMove(toParent: self)
    }
    
    func insertChildVC(_ vc: UIViewController, belowSubview: UIView) {
        self.addChild(vc)
        self.view.insertSubview(vc.view, belowSubview: belowSubview)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        vc.didMove(toParent: self)
    }
    
    func addChildVCWithoutConstraints(_ vc: UIViewController) {
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func addChildVCSimple(_ vc: UIViewController) {
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
}
