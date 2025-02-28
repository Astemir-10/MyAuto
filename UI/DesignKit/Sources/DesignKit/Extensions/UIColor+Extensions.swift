//
//  UIColor+Extensions.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit.UIColor

public extension UIColor {
    convenience init(hex: String) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Удаляем символ # если он есть
        if cleanedHex.hasPrefix("#") {
            cleanedHex.remove(at: cleanedHex.startIndex)
        }
        
        guard cleanedHex.count == 6 || cleanedHex.count == 8 else {
            // Устанавливаем цвет по умолчанию (черный)
            self.init(white: 0.0, alpha: 1.0)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgbValue)
        
        let red, green, blue, alpha: CGFloat
        
        if cleanedHex.count == 6 {
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            alpha = 1.0
        } else { // Если в строке 8 символов
            red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgbValue & 0x000000FF) / 255.0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
