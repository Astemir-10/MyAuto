//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 11.11.2024.
//

import Foundation
import Networking
import SessionManager
import Combine

public protocol GeocoderService {
    func requestGeocoder(longitude: Double, latitude: Double) -> AnyPublisher<GeocoderModel, CoreError>
}

public final class GeocoderServiceImpl: GeocoderService {
    enum GeocoderRequestItem: RequestItem {
        case geocoder(longitude: Double, latitude: Double)
        
        var url: URL {
            return URL(string: Host.geocoder.rawValue)!
        }
        
        var params: RequestServiceHTTPParams {
            switch self {
            case .geocoder(let longitude, let latitude):
                return .query(["lon": String(longitude), "lat": String(latitude), "format": "json"])
            }
            
        }
        
        var cacheKey: String {
            return "geocoder"
        }
    }
    
    private let sessionManager: CombineSessionManager
    
    public init(sessionManager: CombineSessionManager) {
        self.sessionManager = sessionManager
    }
    
    public func requestGeocoder(longitude: Double, latitude: Double) -> AnyPublisher<GeocoderModel, CoreError> {
        sessionManager.request(item: GeocoderRequestItem.geocoder(longitude: longitude, latitude: latitude))
    }
}
