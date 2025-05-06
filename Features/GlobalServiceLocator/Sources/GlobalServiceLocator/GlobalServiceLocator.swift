//
//  GlobalServiceLocator.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 18.09.2024.
//

import Foundation
import AppServices
import Networking
import SessionManager
import CombineCoreData
import LocationManager
import AppFileManager
import AppKeychain

public final class GlobalServiceLocator {
    public static let shared = GlobalServiceLocator()
    
    // MARK: CombineSessionManager
    public var combineSessionManager: CombineSessionManager?
    
    public func getService() -> CombineSessionManager {
        if let combineSessionManager {
            return combineSessionManager
        } else {
            let combineSessionManager = CombineSessionManager()
            self.combineSessionManager = combineSessionManager
            return combineSessionManager
        }
    }
    
    // MARK: CombineCachedSessionManager
    public var combineCachedSessionManager: CombineCachedSessionManager?
    
    public func getService() -> CombineCachedSessionManager {
        if let combineCachedSessionManager {
            return combineCachedSessionManager
        } else {
            let combineCachedSessionManager = CombineCachedSessionManager()
            self.combineCachedSessionManager = combineCachedSessionManager
            return combineCachedSessionManager
        }
    }
    
    
    // MARK: DromCarInfoService
    public var dromCarInfoService: DromCarInfoService?
    
    public func getService() -> DromCarInfoService {
        if let dromCarInfoService {
            return dromCarInfoService
        } else {
            let dromCarService = DromCarInfoService(sessionManager: getService())
            self.dromCarInfoService = dromCarService
            return dromCarService
        }
    }
    
    // MARK: DromCarInfoService
    public var combineCoreData: CombineCoreData?
    
    public func getService() -> CombineCoreData {
        if let combineCoreData {
            return combineCoreData
        } else {
            let combineCoreData = CombineCoreData()
            self.combineCoreData = combineCoreData
            return combineCoreData
        }
    }
    
    // MARK: PetrolService
    public var petrolService: PetrolService?
    
    public func getService() -> PetrolService {
        if let petrolService {
            return petrolService
        } else {
            let petrolService = PetrolServiceImpl(sessionManager: getService())
            self.petrolService = petrolService
            return petrolService
        }
    }
    
    // MARK: WetherService
    public var weatherService: WeatherService?
    
    public func getService() -> WeatherService {
        if let weatherService {
            return weatherService
        } else {
            let weatherService = WeatherServiceImpl(sessionManager: getService())
            self.weatherService = weatherService
            return weatherService
        }
    }
    
    //MARK: GeocoderService
    public var geocoderService: GeocoderService?
    
    public func getService() -> GeocoderService {
        if let geocoderService {
            return geocoderService
        } else {
            let geocoderService = GeocoderServiceImpl(sessionManager: getService())
            self.geocoderService = geocoderService
            return geocoderService
        }
    }
    
    // MARK: AppFileManager
    public var appFileManager: AppFileManager?
    
    public func getService() -> AppFileManager {
        if let appFileManager {
            return appFileManager
        } else {
            let appFileManager = AppFileManager()
            self.appFileManager = appFileManager
            return appFileManager
        }
    }
    
    // MARK: CheckService
    public var checkService: CheckService?
    
    public func getService() -> CheckService {
        if let checkService {
            return checkService
        } else {
            let checkService = CheckServiceImpl(sessionManager: getService())
            self.checkService = checkService
            return checkService
        }
    }
    
    // MARK: AuthorizationService
    public var authorizationService: AuthorizationService?
    
    public func getService() -> AuthorizationService {
        if let authorizationService {
            return authorizationService
        } else {
            let authorizationService = AuthorizationServiceImpl(sessionManager: getService())
            self.authorizationService = authorizationService
            return authorizationService
        }
    }
    
    // MARK: Keychain
    public var appKeychain: AppKeychain?
    
    public func getService() -> AppKeychain {
        if let appKeychain {
            return appKeychain
        } else {
            let appKeychain = AppKeychainImpl(service: "com.myauto.MyAuto")
            self.appKeychain = appKeychain
            return appKeychain
        }
    }
}
