//
//  Fonts.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit

public struct AppFonts {
    public let premiumButton = UIFont.systemFont(ofSize: 18, weight: .bold)
    public let textLarge = UIFont.systemFont(ofSize: 16, weight: .bold)
    public let secondaryButton = UIFont.systemFont(ofSize: 18, weight: .regular)
    public let titleLarge = UIFont.systemFont(ofSize: 28, weight: .bold)
    public let secondaryLarge = UIFont.systemFont(ofSize: 16, weight: .regular)
    public let secondaryNeutral = UIFont.systemFont(ofSize: 14, weight: .regular)
    public let secondaryMedium = UIFont.systemFont(ofSize: 14, weight: .medium)
    public let smallNeutral = UIFont.systemFont(ofSize: 12, weight: .regular)
    public let neutral = UIFont.systemFont(ofSize: 17, weight: .regular)
    public let textBold = UIFont.systemFont(ofSize: 22, weight: .bold)
    public let textMedium = UIFont.systemFont(ofSize: 20, weight: .medium)
    public let textSemibold = UIFont.systemFont(ofSize: 20, weight: .semibold)
    public let textRegular = UIFont.systemFont(ofSize: 20, weight: .regular)
    public let neutralMedium = UIFont.systemFont(ofSize: 16, weight: .medium)
    public let largeNeutralSemibold = UIFont.systemFont(ofSize: 17, weight: .semibold)
    public let largeMedium = UIFont.systemFont(ofSize: 28, weight: .medium)
    public let largeBold = UIFont.systemFont(ofSize: 28, weight: .bold)
    public let descriptionSmall = UIFont.systemFont(ofSize: 14, weight: .regular)
    public let neutralSemibold = UIFont.systemFont(ofSize: 16, weight: .semibold)
}

public extension UIFont {
    static let appFonts = AppFonts()
}
