//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import Foundation
import Extensions
import AnyFormatter

public struct WeatherResponse: Decodable {
    public let weather: WeatherData
}

public struct WeatherData: Decodable {
    public let latitude: Double
    public let longitude: Double
    public let timezone: String
    public let timezoneAbbreviation: String
    public let elevation: Double
    public let generationtimeMs: Double
    public let utcOffsetSeconds: Int
    public let dailyUnits: DailyUnits
    public let days: [Day]

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case generationtimeMs = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case dailyUnits = "daily_units"
        case days
    }
}

public struct DailyUnits: Decodable {
    public let time: String
    public let temperature2mMax: String
    public let temperature2mMin: String
    public let precipitationSum: String
    public let weathercode: String
    public let snowfallSum: String
    public let precipitationProbabilityMax: String
    public let windspeed10mMax: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case precipitationSum = "precipitation_sum"
        case weathercode
        case snowfallSum = "snowfall_sum"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case windspeed10mMax = "windspeed_10m_max"
    }
}

public struct Day: Decodable {
    public let time: String
    public let tempMax: Double
    public let tempMin: Double
    public let precipitationSum: Double
    public let weatherCode: WeatherCode
    public let snowfallSum: Double
    public let precipitationProbability: Int
    public let windspeedMax: Double
    
    enum CodingKeys: CodingKey {
        case time
        case tempMax
        case tempMin
        case precipitationSum
        case weatherCode
        case snowfallSum
        case precipitationProbability
        case windspeedMax
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try container.decode(String.self, forKey: .time)
        self.tempMax = try container.decode(Double.self, forKey: .tempMax)
        self.tempMin = try container.decode(Double.self, forKey: .tempMin)
        self.precipitationSum = try container.decode(Double.self, forKey: .precipitationSum)
        self.weatherCode = .init(rawValue: try container.decode(Int.self, forKey: .weatherCode)) ?? .none
        self.snowfallSum = try container.decode(Double.self, forKey: .snowfallSum)
        self.precipitationProbability = try container.decode(Int.self, forKey: .precipitationProbability)
        self.windspeedMax = try container.decode(Double.self, forKey: .windspeedMax)
    }
    
}

public enum WeatherCode: Int, Decodable {
    case none = 100000
    
    case clear = 0 // Ясно
    
    case mainlyClear = 1 // Приемущественно ясно
    case partlyCloudy = 2 // Переменная облачность
    case overcast = 3 // Пасмурно
    
    // Туман
    case fog = 45 // обычный туман, который может снижать видимость, но не обязательно сопровождается образованием ряби или инея
    case depositingRimeFog = 48 // более специфический тип тумана, который образует иней на объектах (деревьях, проводах, зданиях) из-за конденсации водяного пара

    // Моросящий дождь
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleHeavy = 55
    
    // Холодный моросящий дождь Когда капли дождя соприкасаются с холодной поверхностью, они мгновенно замерзают, образуя слой льда. Это может создать очень опасные условия на дорогах, так как лед делает поверхность скользкой и увеличивает риск аварий.
    case freezingDrizzleLight = 56
    case freezingDrizzleHeavy = 57
    
    // Дождь
    case lightRain = 61 // слабый дождь
    case moderatetRain = 63 // умеренный дождь
    case heavyRain = 65 // сильный дождь

    // Замерзающий дождь Когда капли дождя соприкасаются с холодной поверхностью, они мгновенно замерзают, образуя слой льда. Это может создать очень опасные условия на дорогах, так как лед делает поверхность скользкой и увеличивает риск аварий.
    case freezingLightRain = 66
    case freezingHeavyRain = 67
    
    // Снег
    case lightSnow = 71 // слабый снег
    case moderatetSnow = 73 // умеренный снег
    case heavySnow = 75 // сильный снег
    case snowGrains = 77
    
    // Ливнивые дожди
    case lightRainShowers = 80 // слабый
    case moderatetRainShowers = 81 // умеренный
    case heavyRainShowers = 82 // сильный


    // Град/Гроза
    case lightThunderstorm = 95 // слабый / умеренный
    case moderatetThunderstormWithHail = 96 // умеренный град
    case heavyThunderstormWithHail = 99 // сильный град


    
    /*
     0    Clear sky
     1, 2, 3    Mainly clear, partly cloudy, and overcast
     45, 48    Fog and depositing rime fog
     51, 53, 55    Drizzle: Light, moderate, and dense intensity
     56, 57    Freezing Drizzle: Light and dense intensity
     61, 63, 65    Rain: Slight, moderate and heavy intensity
     66, 67    Freezing Rain: Light and heavy intensity
     71, 73, 75    Snow fall: Slight, moderate, and heavy intensity
     77    Snow grains
     80, 81, 82    Rain showers: Slight, moderate, and violent
     85, 86    Snow showers slight and heavy
     95 *    Thunderstorm: Slight or moderate
     96, 99 *    Thunderstorm with slight and heavy hail
     */
    
    
    /*
     Туман (Fog):

     Коды: 45, 48
     Описание: Погода с туманом может существенно ухудшать видимость, что особенно важно для водителей. Вы можете создать предупреждение для пользователей о потенциально опасных условиях.
     Дождь (Rain):

     Коды: 61, 63, 65 (слабый, умеренный и сильный)
     Описание: Дождь может увеличить риск аквапланирования и ухудшить видимость. Уведомления о дожде могут помочь водителям подготовиться к условиям.
     Снег (Snow):

     Коды: 71, 73, 75 (слабый, умеренный и сильный)
     Описание: Снег создает дополнительные проблемы на дорогах. Сообщения о снежных условиях могут помочь водителям избегать небезопасных участков.
     Град (Hail):

     Коды: 96, 99 (с небольшим и сильным градом)
     Описание: Уведомления о граде могут помочь водителям найти укрытие или принять другие меры предосторожности.
     Гроза (Thunderstorm):

     Коды: 95 (слабая или умеренная), 96, 99 (с небольшим и сильным градом)
     Описание: Грозы могут сопровождаться сильными дождями и шквалами ветра, что также представляет опасность для водителей.
     */
}
