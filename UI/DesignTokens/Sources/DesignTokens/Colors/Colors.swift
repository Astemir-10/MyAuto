//
//  Colors.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit

public struct AppColors {
    public struct TextColors {
        // primary light: #000000; dark: #ffffff
        public let primary = UIColor.colorBy(named: "primaryApp")
        
        // secondary light: #616161; dark: ACACAC
        public let secondary = UIColor.colorBy(named: "secondaryApp")
        
        // secondary #C4C4C4
        public let secondaryLight = UIColor.colorBy(named: "secondaryLight")
                
        // primaryAppOnDark #000000
        public let primaryAppOnDark = UIColor.colorBy(named: "primaryAppOnDark")
        
        // blueApp #4D70EC
        public let blue = UIColor.colorBy(named: "blueApp")
    }
    
    public struct UIColors {
        public let tabBar = TabBar()
        // main light: #ffffff; dark: #000000
        public let main = UIColor.colorBy(named: "main")
        
        // mainSecondary light: #ffffff; dark: #000000
        public let mainSecondary = UIColor.colorBy(named: "mainSecondary")
        
        // primaryAlternative light: #ffffff; dark: #262626
        public let primaryAlternative = UIColor.colorBy(named: "primaryAlternative")
        
        // secondary #777777
        public let secondaryUI = UIColor.colorBy(named: "secondaryUI")
        
        // primaryButton #5450FF
        public let primaryButton = UIColor.colorBy(named: "primaryButton")
        
        // gray #
        public let gray = UIColor.colorBy(named: "gray")
        
        // primaryAlternativeSecondary #
        public let primaryAlternativeSecondary = UIColor.colorBy(named: "primaryAlternativeSecondary")
        
        public let primaryAlternativeThirdty = UIColor.colorBy(named: "primaryAlternativeThirdty")
        
    }
    
    public struct TabBar {
        public let background = UIColor.colorBy(named: "tabBar.background")
        public let tabSelected = UIColor.colorBy(named: "tabBar.iconSelected")
        public let tabNormal = UIColor.colorBy(named: "tabBar.iconNormal")
    }
    
    public struct Weather {
        public let sun = UIColor.colorBy(named: "sun")
        public let cloudSun = UIColor.colorBy(named: "cloudSun")
        public let cloud = UIColor.colorBy(named: "cloud")
        public let cloudFog = UIColor.colorBy(named: "cloudFog")
        public let cloudSnow = UIColor.colorBy(named: "cloudSnow")
        public let drizzle = UIColor.colorBy(named: "drizzle")
        public let rain = UIColor.colorBy(named: "rain")
        public let heavyrain = UIColor.colorBy(named: "heavyrain")
        public let snowflake = UIColor.colorBy(named: "snowflake")
        public let snow = UIColor.colorBy(named: "snow")
        public let snowflakeCircle = UIColor.colorBy(named: "snowflakeCircle")
        public let cludBolt = UIColor.colorBy(named: "cludBolt")
        public let cloudBoltRain = UIColor.colorBy(named: "cloudBoltRain")

    }
    
    public let text: TextColors = TextColors()
    public let ui: UIColors = UIColors()
    public let weather: Weather = Weather()
    
}

public extension UIColor {
    static let appColors = AppColors()
    
    static func colorBy(named: String) -> UIColor {
        if let color = UIColor(named: named, in: .module, compatibleWith: nil) {
            return color
        }
        fatalError("Not find color by named \(named)")
    }
}


