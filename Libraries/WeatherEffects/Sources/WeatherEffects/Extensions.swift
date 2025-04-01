//
//  File.swift
//  WeatherEffects
//
//  Created by Astemir Shibzuhov on 03.03.2025.
//

import UIKit

extension CGImage {
    static func drawRainDrop() -> CGImage? {
        let size = CGSize(width: 10, height: 30)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    static func drawPoint() -> CGImage? {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    static func drawLine() -> CGImage? {
        let size = CGSize(width: 420, height: 5)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    static func blurCGImage(_ image: CGImage, radius: CGFloat) -> CGImage? {
        let ciImage = CIImage(cgImage: image)
        let context = CIContext()
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputImage = blurFilter?.outputImage else {
            return nil
        }
        
        return context.createCGImage(outputImage, from: outputImage.extent)
    }
}
