//
//  File.swift
//  DesignTokens
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit

public struct AppImages {
    public struct Icons {
        public let close = UIImage.fromResources(by: "close")
    }
    
    public struct Brands {
        public let rosneft = UIImage.fromResources(by: "rosneft")
        public let lukoil = UIImage.fromResources(by: "lukoil")
        public let gazpromneft = UIImage.fromResources(by: "gazpromneft")
    }
    
    public let icons: Icons = Icons()
    public let brands: Brands = Brands()
}

public extension UIImage {
    static let appImages = AppImages()
    
}

public extension UIImage {
    static func fromResources(by named: String) -> UIImage {
        guard let image = self.init(named: named, in: .module, with: nil) else {
            fatalError("Not found image by named \(named)")
        }
        return image
    }
}
