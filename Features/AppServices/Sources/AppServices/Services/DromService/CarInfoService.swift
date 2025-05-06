//
//  CarInfoService.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 14.08.2024.
//

import Foundation
import Networking
import SessionManager
import Combine
import Extensions

public protocol CarInfoService {
    func getToken(number: String) -> AnyPublisher<DromTokenModel, CoreError>
    func checkGibddCarInfo(token: String) -> AnyPublisher<CarInfoModel, CoreError>
}

public final class DromCarInfoService: CarInfoService {
    
    enum DromCarRequest: RequestItem {
        case getToken(number: String), checkGibddCarInfo(token: String)
        
        var url: URL {
            URL(string: Host.drom.rawValue)!
        }
        
        var headers: [String : String] {
            switch self {
            case .getToken:
                [
                    "Host": "auto.drom.ru",
                    "Accept": "*/*",
                    "Sec-Fetch-Site": "same-site",
                    "Accept-Language": "ru",
                    "Sec-Fetch-Mode": "cors",
                    "Origin": "https://vin.drom.ru",
                    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15",
                    "Referer": "https://vin.drom.ru/report/%D0%9D558%D0%9C%D0%9C07/?utm_source=main_vin_dr&utm_medium=button&utm_campaign=report_by_vin",
                    "Sec-Fetch-Dest": "empty"
                ]
            case .checkGibddCarInfo:
                [
                    "Host": "auto.drom.ru",
                    "Accept": "*/*",
                    "Sec-Fetch-Site": "same-site",
                    "Accept-Language": "ru",
                    "Sec-Fetch-Mode": "cors",
                    "Origin": "https://vin.drom.ru",
                    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15",
                    "Referer": "https://vin.drom.ru/report/%D0%9D558%D0%9C%D0%9C07/?utm_source=main_vin_dr&utm_medium=button&utm_campaign=report_by_vin",
                    "Sec-Fetch-Dest": "empty"
                ]
            }
        }
        
        var method: Networking.HTTPMethod {
            .post
        }
        
        var cacheKey: String {
            switch self {
            case .getToken:
                "getToken"
            case .checkGibddCarInfo:
                "checkGibddCarInfo"
            }
        }
        
        var body: HTTPData? {
            switch self {
            case .getToken(let number):
                return .formData(["token": nil, "carplate": number])
            case .checkGibddCarInfo(let token):
                return .formData(["token": token])
            }
        }
        
        var params: RequestServiceHTTPParams {
            switch self {
            case .getToken:
                return .query(["mode":"check_autohistory_report_captha", "crossdomain_ajax_request": "3"])
            case .checkGibddCarInfo:
                return .query(["mode":"check_autohistory_gibdd_info", "crossdomain_ajax_request": "3"])

            }
        }
    }
    
    private let sessionManager: CombineSessionManager
    
    public func getToken(number: String) -> AnyPublisher<DromTokenModel, Networking.CoreError> {
        return sessionManager.request(item: DromCarRequest.getToken(number: number))
    }
    
    public func checkGibddCarInfo(token: String) -> AnyPublisher<CarInfoModel, Networking.CoreError> {
        
        sessionManager.request(item: DromCarRequest.checkGibddCarInfo(token: token))
    }
    
    public init(sessionManager: CombineSessionManager) {
        self.sessionManager = sessionManager
    }
}
