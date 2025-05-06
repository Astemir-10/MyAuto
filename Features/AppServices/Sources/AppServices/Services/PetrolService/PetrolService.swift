//
//  PetrolService.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 03.11.2024.
//

import Foundation
import Networking
import SessionManager
import Combine
import Extensions

extension URL {
    enum Path: String {
        case petrol, regions, prices
        case weather, getWeather, getHourlyWeather
        case check, car, fines, driver, driverCard
        case auth, login, logout, registration, confirm, refreshToken
    }
    
    func appendApiPath(_ paths: Path..., needGateway: Bool = true) -> URL {
        guard var components = URLComponents(string: self.absoluteString) else {
            fatalError("Invalid URL")
        }
        if needGateway {
            components.path.append("/gateway")
        }
        paths.forEach({
            components.path.append("/" + $0.rawValue)
        })
        return components.url!
    }
}

public enum ApiUrl {
    static var url: URL {
        URL(string: "https://api.car-mate.ru")!
    }
}

public struct PetrolInfoListItem: Decodable {
    public let id: String
    public let value: String
}

public struct Regions: Decodable {
    
    public let regions: [PetrolInfoListItem]
}

public struct Brands: Decodable {
    public let brands: [PetrolInfoListItem]
}

public struct Cities: Decodable {
    public let cities: [PetrolInfoListItem]
}


public protocol PetrolService {
    func cachedOrRequestedPricesInfo(region: String) -> AnyPublisher<PetrolStationsResponse, CoreError>
    func cachedOrRequestedRegions() -> AnyPublisher<Regions, CoreError>
}

public struct Location {
    public let lat: Double
    public let lng: Double
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

public final class PetrolServiceImpl: PetrolService {
    
    private let sessionManager: CombineSessionManager
    
    public init(sessionManager: CombineSessionManager) {
        self.sessionManager = sessionManager
    }
    
    public func cachedOrRequestedPricesInfo(region: String) -> AnyPublisher<PetrolStationsResponse, CoreError> {
        sessionManager.request(item: PetrolServiceRequestItem.prices(region: region))
    }
    
    public func cachedOrRequestedRegions() -> AnyPublisher<Regions, CoreError> {
        sessionManager.request(item: PetrolServiceRequestItem.regions)
    }
}

extension PetrolServiceImpl {
    enum PetrolServiceRequestItem: RequestItem {
        case regions
        case prices(region: String)
        var url: URL {
            switch self {
            case .regions:
                return ApiUrl.url.appendApiPath(.petrol, .regions)
            case .prices:
                return ApiUrl.url.appendApiPath(.petrol, .prices)
            }
        }
        
        var cacheKey: String {
            switch self {
            case .regions:
                return "regions"
            case .prices:
                return "prices"
            }
        }
        
        var params: RequestServiceHTTPParams {
            switch self {
            case .regions:
                return .query([:])
            case .prices(let region):
                return .query(["region": region])
            }
        }
        
        var needLogCurl: Bool {
            switch self {
            case .regions:
                return true
            case .prices:
                return true
            }
        }
        
        var jsonDecoder: JSONDecoder { JSONDecoder() }
    }
    
}
