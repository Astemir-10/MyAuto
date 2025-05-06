//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 01.05.2025.
//

import Foundation
import SessionManager
import Networking
import Combine
import Extensions


public protocol CheckService {
    func requestCarInfo(by vin: String) -> AnyPublisher<CarRegisterResponse, CoreError>
    func requestFines(sts: String, plate: String) -> AnyPublisher<FineResponse, CoreError>
    func requestDriver(number: String, date: Date) -> AnyPublisher<DriverModel, CoreError>
    func requestDriverCard(vin: String) -> AnyPublisher<DriverCardModel, CoreError>
}

public final class CheckServiceImpl: CheckService {
    
    private let sessionManager: CombineSessionManager
    
    public init(sessionManager: CombineSessionManager) {
        self.sessionManager = sessionManager
    }

    public func requestCarInfo(by vin: String) -> AnyPublisher<CarRegisterResponse, CoreError> {
        sessionManager.request(item: CheckServiceRequestItem.carInfo(vin: vin))
    }
    
    public func requestFines(sts: String, plate: String) -> AnyPublisher<FineResponse, CoreError> {
        sessionManager.request(item: CheckServiceRequestItem.fines(sts: sts, plate: plate))
    }
    
    public func requestDriver(number: String, date: Date) -> AnyPublisher<DriverModel, CoreError> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: date)
        return sessionManager.request(item: CheckServiceRequestItem.driver(number: number, date: date))
    }
    
    public func requestDriverCard(vin: String) -> AnyPublisher<DriverCardModel, Networking.CoreError> {
        sessionManager.request(item: CheckServiceRequestItem.driverCard(vin: vin))
    }
}
extension CheckServiceImpl {
    enum CheckServiceRequestItem: RequestItem {
        case carInfo(vin: String), driverCard(vin: String), fines(sts: String, plate: String), driver(number: String, date: String)
        var url: URL {
            switch self {
            case .carInfo:
                return ApiUrl.url.appendApiPath(.check, .car)
            case .fines:
                return ApiUrl.url.appendApiPath(.check, .fines)
            case .driver:
                return ApiUrl.url.appendApiPath(.check, .driver)
            case .driverCard:
                return ApiUrl.url.appendApiPath(.check, .driverCard)
            }
        }
        
        var cacheKey: String {
            switch self {
            case .carInfo:
                return "checkCarInfo"
            case .fines:
                return "checkFines"
            case .driver:
                return "checkDriver"
            case .driverCard:
                return "checkDriverCard"
            }
        }
        
        var params: RequestServiceHTTPParams {
            switch self {
            case .carInfo(let vin):
                return .query(["vin":vin])
            case .fines(let sts, let plate):
                return .query(["sts":sts, "plate": plate])
            case .driver(let number, let date):
                return .query(["number":number, "date": date])
            case .driverCard(let vin):
                return .query(["vin":vin])
            }
        }
        
        var needLogCurl: Bool {
            return false
        }
        
        var jsonDecoder: JSONDecoder { JSONDecoder() }
        
    }
    
}
