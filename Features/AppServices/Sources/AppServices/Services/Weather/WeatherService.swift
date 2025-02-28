//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import Foundation
import Combine
import Networking

public protocol WeatherService {
    func requestForecast(lat: Double, lng: Double) -> AnyPublisher<WeatherData, CoreError>
}

public class WeatherServiceImpl: WeatherService {
    enum WetherServiceRequestItem: RequestItem {
        case weather(lat: Double, lon: Double)
        
        var url: URL {
            ApiUrl.url.appendApiPath(.weather, .getWeather)
        }
        
        var cacheKey: String {
            "weatherKey"
        }
        
        var params: RequestServiceHTTPParams {
            switch self {
            case .weather(let lat, let lon):
                return .query(["longitude":String(lon),
                               "latitude": String(lat)])
            }
        }
        
        var jsonDecoder: JSONDecoder { JSONDecoder() }
    }
    
    private let sessionManager: CombineCachedSessionManager
    
    public init(sessionManager: CombineCachedSessionManager) {
        self.sessionManager = sessionManager
    }
    
    public func requestForecast(lat: Double, lng: Double) -> AnyPublisher<WeatherData, CoreError> {
        let response: AnyPublisher<WeatherResponse, CoreError> = sessionManager.request(item: WetherServiceRequestItem.weather(lat: lat, lon: lng))
        return response.map({ $0.weather }).eraseToAnyPublisher()
    }
}
