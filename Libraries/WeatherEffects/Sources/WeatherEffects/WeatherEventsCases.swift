//
//  WeatherEventsCases.swift
//  WeatherEffects
//
//  Created by Олег Романов on 20.07.2024.
//

import Foundation

public enum WeatherEvents: String, CaseIterable {
    case clear
    case rain
    case heavyRain
    case cloudy
    case storm
    case snow
    case snowWithRain
    case blizzard
    case fog
    case windy
    
    var iconSystemName: String {
        get {
            switch self {
                case .clear:
                    return "sun.max.fill"
                case .rain:
                    return "cloud.rain.fill"
                case .heavyRain:
                    return "cloud.heavyrain.fill"
                case .cloudy:
                    return "smoke.fill"
                case .storm:
                    return "cloud.bolt.rain.fill"
                case .snow:
                    return "cloud.snow.fill"
                case .snowWithRain:
                    return "cloud.sleet.fill"
                case .blizzard:
                    return "wind.snow"
                case .fog:
                    return "cloud.fog.fill"
                case .windy:
                    return "wind"
            }
        }
    }
}
