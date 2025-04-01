//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import UIKit
import SkeletonView


public extension UIView {
    func showSkeletonAnimation(cornerRadius: CGFloat = 10) {
        self.isSkeletonable = true
        let animation = GradientDirection.leftRight.slidingAnimation()
        self.skeletonCornerRadius = Float(cornerRadius)
        showAnimatedGradientSkeleton(animation: animation)
    }
}
