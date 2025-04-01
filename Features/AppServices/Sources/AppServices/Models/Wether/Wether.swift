//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import Foundation
import UIKit
import DesignTokens
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
    
    public init(latitude: Double, longitude: Double, timezone: String, timezoneAbbreviation: String, elevation: Double, generationtimeMs: Double, utcOffsetSeconds: Int, dailyUnits: DailyUnits, days: [Day]) {
        self.latitude = latitude
        self.longitude = longitude
        self.timezone = timezone
        self.timezoneAbbreviation = timezoneAbbreviation
        self.elevation = elevation
        self.generationtimeMs = generationtimeMs
        self.utcOffsetSeconds = utcOffsetSeconds
        self.dailyUnits = dailyUnits
        self.days = days
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
    
    public init(time: String, temperature2mMax: String, temperature2mMin: String, precipitationSum: String, weathercode: String, snowfallSum: String, precipitationProbabilityMax: String, windspeed10mMax: String) {
        self.time = time
        self.temperature2mMax = temperature2mMax
        self.temperature2mMin = temperature2mMin
        self.precipitationSum = precipitationSum
        self.weathercode = weathercode
        self.snowfallSum = snowfallSum
        self.precipitationProbabilityMax = precipitationProbabilityMax
        self.windspeed10mMax = windspeed10mMax
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
    
    public init(time: String, tempMax: Double, tempMin: Double, precipitationSum: Double, weatherCode: WeatherCode, snowfallSum: Double, precipitationProbability: Int, windspeedMax: Double) {
        self.time = time
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.precipitationSum = precipitationSum
        self.weatherCode = weatherCode
        self.snowfallSum = snowfallSum
        self.precipitationProbability = precipitationProbability
        self.windspeedMax = windspeedMax
    }
    
}

public enum WeatherCode: Int, Codable {
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
    
    public var description: String {
        switch self {
        case .none:
            return "Нет данных о погоде."
            
        case .clear:
            return "Ясная погода. Отличные условия для поездки!"
            
        case .mainlyClear:
            return "Преимущественно ясно. Возможна небольшая облачность."
            
        case .partlyCloudy:
            return "Переменная облачность. Хорошая видимость на дороге."
            
        case .overcast:
            return "Пасмурно. Осадки маловероятны, но освещение снижено."
            
        case .fog:
            return "Туман. Будьте осторожны, снижена видимость!"
            
        case .depositingRimeFog:
            return "Ледяной туман. Возможен гололед, соблюдайте дистанцию."
            
        case .drizzleLight:
            return "Мелкая морось. Дорога может быть влажной, увеличьте тормозной путь."
            
        case .drizzleModerate:
            return "Умеренная морось. Дорожное покрытие скользкое, будьте внимательны."
            
        case .drizzleHeavy:
            return "Сильная морось. Включите дворники и снижайте скорость."
            
        case .freezingDrizzleLight:
            return "Легкий замерзающий дождь. Возможен гололед, будьте осторожны."
            
        case .freezingDrizzleHeavy:
            return "Сильный замерзающий дождь. Опасность обледенения дороги!"
            
        case .lightRain:
            return "Небольшой дождь. Дорога влажная, будьте аккуратны."
            
        case .moderatetRain:
            return "Умеренный дождь. Снижается сцепление с дорогой."
            
        case .heavyRain:
            return "Сильный дождь. Возможен аквапланинг, снижайте скорость!"
            
        case .freezingLightRain:
            return "Легкий ледяной дождь. Высокий риск скольжения."
            
        case .freezingHeavyRain:
            return "Сильный ледяной дождь! По возможности избегайте поездок."
            
        case .lightSnow:
            return "Небольшой снег. Возможны заносы на дороге."
            
        case .moderatetSnow:
            return "Умеренный снег. Видимость снижена, соблюдайте дистанцию."
            
        case .heavySnow:
            return "Сильный снегопад! Возможны пробки и ухудшение видимости."
            
        case .snowGrains:
            return "Снежная крупа. Возможна скользкая дорога."
            
        case .lightRainShowers:
            return "Небольшие ливневые дожди. Включите дворники."
            
        case .moderatetRainShowers:
            return "Умеренные ливни. Следите за состоянием дороги."
            
        case .heavyRainShowers:
            return "Сильные ливни! Возможны подтопления дорог."
            
        case .lightThunderstorm:
            return "Слабая гроза. Будьте внимательны к внезапным порывам ветра."
            
        case .moderatetThunderstormWithHail:
            return "Гроза с градом. Опасность повреждения автомобиля!"
            
        case .heavyThunderstormWithHail:
            return "Сильная гроза с градом! По возможности укройтесь в безопасном месте."
        }
    }
    
    public var iconColor: UIColor {
        switch self {
        case .none:
                .white
        case .clear, .mainlyClear:
                .appColors.weather.sun
        case .partlyCloudy:
                .appColors.weather.cloudSun
        case .overcast:
                .appColors.weather.cloud
        case .fog, .depositingRimeFog:
                .appColors.weather.cloudFog
            
        case .lightRain, .moderatetRain, .freezingDrizzleHeavy, .freezingDrizzleLight, .drizzleHeavy, .lightRainShowers, .moderatetRainShowers, .heavyRainShowers, .drizzleLight, .drizzleModerate:
                .appColors.weather.rain
            
        case .freezingLightRain, .freezingHeavyRain, .heavyRain:
                .appColors.weather.rain
        case .lightSnow, .moderatetSnow, .heavySnow:
                .appColors.weather.snowflake
        case .snowGrains:
                .appColors.weather.snowflakeCircle
        case .lightThunderstorm:
                .appColors.weather.cloudBoltRain
        case .moderatetThunderstormWithHail, .heavyThunderstormWithHail:
                .appColors.weather.cloudBoltRain
        }
    }
    
    public var icon: UIImage {
        switch self {
        case .none:
                .appImages.weather.sun
        case .clear:
                .appImages.weather.sun
        case .mainlyClear:
                .appImages.weather.sun
        case .partlyCloudy:
                .appImages.weather.cloudWithSun
        case .overcast:
                .appImages.weather.cloud
        case .fog:
                .appImages.weather.cloudWithFog
        case .depositingRimeFog:
                .appImages.weather.cloudWithFog
        case .drizzleLight:
                .appImages.weather.cloudWithDrizzle
        case .drizzleModerate:
                .appImages.weather.cloudWithDrizzle
        case .drizzleHeavy:
                .appImages.weather.cloudWithDrizzle
        case .freezingDrizzleLight:
                .appImages.weather.cloudWithDrizzle
        case .freezingDrizzleHeavy:
                .appImages.weather.cloudWithDrizzle
        case .lightRain:
                .appImages.weather.cloudWithRain
        case .moderatetRain:
                .appImages.weather.cloudWithRain
        case .heavyRain:
                .appImages.weather.cloudWithShower
        case .freezingLightRain:
                .appImages.weather.cloudWithRain
        case .freezingHeavyRain:
                .appImages.weather.cloudWithShower
        case .lightSnow:
                .appImages.weather.cloudWithSnow
        case .moderatetSnow:
                .appImages.weather.cloudWithSnow
        case .heavySnow:
                .appImages.weather.cloudWithSnow
        case .snowGrains:
                .appImages.weather.cloudWithSnow
        case .lightRainShowers:
                .appImages.weather.cloudWithRain
        case .moderatetRainShowers:
                .appImages.weather.cloudWithRain
        case .heavyRainShowers:
                .appImages.weather.cloudWithShower
        case .lightThunderstorm:
                .appImages.weather.cloudWithLightThunderstorm
        case .moderatetThunderstormWithHail:
                .appImages.weather.cloudWithLightThunderstorm
        case .heavyThunderstormWithHail:
                .appImages.weather.cloudWithHeavyThunderstorm
        }
    }
}



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

public struct WeatherHourlyData: Codable {
    public let weather: WeatherHourly
}

public struct WeatherHourly: Codable {
    public let latitude: Double
    public let longitude: Double
    public let generationtimeMs: Double
    public let utcOffsetSeconds: Int
    public let timezone: String
    public let timezoneAbbreviation: String
    public let elevation: Double
    public let hourlyUnits: HourlyUnits
    public let hourly: [HourlyWeather]
}

public struct HourlyUnits: Codable {
    public let time: String
    public let temperature2m: String
    public let windSpeed10m: String
    public let precipitation: String
    public let snowfall: String
    public let precipitationProbability: String
    public let rain: String
    public let showers: String
    public let weatherCode: String
    public let visibility: String
}

public struct HourlyWeather: Codable {
    public let date: Date
    public let temperature2m: Double
    public let windSpeed10m: Double
    public let precipitation: Double
    public let snowfall: Double
    public let precipitationProbability: Int
    public let rain: Double
    public let showers: Double
    public let weatherCode: WeatherCode
    public let visibility: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "time"
        case temperature2m
        case windSpeed10m
        case precipitation
        case snowfall
        case precipitationProbability
        case rain
        case showers
        case weatherCode
        case visibility
    }
    
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let date = try container.decode(String.self, forKey: .date).toDate(dateForamtter: .iso8601) {
            self.date = date
        } else {
            self.date = Date()
        }
        self.temperature2m = try container.decode(Double.self, forKey: .temperature2m)
        self.windSpeed10m = try container.decode(Double.self, forKey: .windSpeed10m)
        self.precipitation = try container.decode(Double.self, forKey: .precipitation)
        self.snowfall = try container.decode(Double.self, forKey: .snowfall)
        self.precipitationProbability = try container.decode(Int.self, forKey: .precipitationProbability)
        self.rain = try container.decode(Double.self, forKey: .rain)
        self.showers = try container.decode(Double.self, forKey: .showers)
        if let weatherCode = WeatherCode(rawValue: try container.decode(Int.self, forKey: .weatherCode)) {
            self.weatherCode = weatherCode
        } else {
            weatherCode = .none
        }
        self.visibility = try container.decode(Double.self, forKey: .visibility)
    }
}
