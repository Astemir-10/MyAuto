//
//  UIView+Extensions.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 14.08.2024.
//

import UIKit

public extension UIView {
    enum Constraint {
        case leading(CGFloat)
        case trailing(CGFloat)
        case bottom(CGFloat)
        case top(CGFloat)
        case heightConstatnt(CGFloat)
        case widthConstatnt(CGFloat)
        case centerX(CGFloat)
        case centerY(CGFloat)
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach({
            self.addSubview($0)
        })
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach({
            self.addSubview($0)
        })
    }
    @discardableResult
    func addConstraintToSuperView(_ constraints: [Constraint]) -> [NSLayoutConstraint] {
        guard let superview else { return [] }
        return self.addConstraintTo(view: superview, constraints)
    }
    
    @discardableResult
    func addConstraintForCloseButton() -> [NSLayoutConstraint] {
        guard let superview else { return [] }
        return self.addConstraintTo(view: superview, [.trailing(-20), .top(20)], withSafeArea: true)
    }
    
    func addConstraintToSuperView(_ constraints: [Constraint], withSafeArea: Bool) {
        guard let superview else { return }
        self.addConstraintTo(view: superview, constraints, withSafeArea: withSafeArea)
    }
    
    @discardableResult
    func addConstraintTo(view: UIView, _ constraints: [Constraint], withSafeArea: Bool = false) -> [NSLayoutConstraint] {
        self.forAutoLayout()
        var constraintsArray = [NSLayoutConstraint]()
        constraints.forEach({
            switch $0 {
            case .leading(let constant):
                constraintsArray.append(self.leadingAnchor.constraint(equalTo: withSafeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: constant).activated())
            case .top(let constant):
                constraintsArray.append(self.topAnchor.constraint(equalTo: withSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: constant).activated())
            case .trailing(let constant):
                constraintsArray.append(self.trailingAnchor.constraint(equalTo: withSafeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, constant: constant).activated())
            case .bottom(let constant):
                constraintsArray.append(self.bottomAnchor.constraint(equalTo: withSafeArea ?  view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: constant).activated())
            case .heightConstatnt(let constant):
                constraintsArray.append(self.heightAnchor.constraint(equalToConstant: constant).activated())
            case .widthConstatnt(let constant):
                constraintsArray.append(self.widthAnchor.constraint(equalToConstant: constant).activated())
            case .centerX(let constant):
                constraintsArray.append(self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).activated())
            case .centerY(let constant):
                constraintsArray.append(self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).activated())
            }
        })
        return constraintsArray
    }
    
    @discardableResult
    func forAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        if let width {
            self.widthAnchor.constraint(equalToConstant: width).activated()
        }
        
        if let height {
            self.heightAnchor.constraint(equalToConstant: height).activated()
        }
    }
    
    func addSubviewCentered(_ subview: UIView) {
        subview.forAutoLayout()
        self.addSubview(subview)
        subview.centerYAnchor.constraint(equalTo: self.centerYAnchor).activated()
        subview.centerXAnchor.constraint(equalTo: self.centerXAnchor).activated()
    }
}

public extension NSLayoutConstraint {
    @discardableResult
    func activated() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }
}

public extension UIViewController {
    func addChildViewController(_ childViewController: UIViewController) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }

    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}


public extension UIDevice {
    static func isRunningOnM1Mac() -> Bool {
        if #available(iOS 14.0, *) {
            let processInfo = ProcessInfo()
            if processInfo.isiOSAppOnMac && processInfo.isMacCatalystApp {
                // Проверяем версию операционной системы, чтобы убедиться, что это устройство с процессором M1
                if processInfo.operatingSystemVersion.majorVersion >= 11 {
                    return true
                }
            }
        }
        return false
    }
    
    
}

//extension UIApplication {
//    static func setInterfaceOrientation(_ orientation: UIInterfaceOrientationMask) {
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)
//            windowScene.requestGeometryUpdate(geometryPreferences) { error in
//                    print("Error: \(error)")
//            }
//        }
//    }
//}

public extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach({
            self.addArrangedSubview($0)
        })
    }
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach({
            self.addArrangedSubview($0)
        })
    }

}

