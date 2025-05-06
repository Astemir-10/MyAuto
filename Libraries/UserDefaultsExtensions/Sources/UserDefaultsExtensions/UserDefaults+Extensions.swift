//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import Foundation
import UIKit

public enum UserDefaultsName: String {
    case obdScannerId, userLongitude, userLatitude, userRegion, userId
}

public final class AppDefaults {
    static let shared: AppDefaults = AppDefaults()
    private init() {}
    
    public func set(name: UserDefaultsName, string: String) {
        UserDefaults.standard.set(string, forKey: name.rawValue)
    }
    
    public func string(by name: UserDefaultsName) -> String? {
        UserDefaults.standard.string(forKey: name.rawValue)
    }
    
    public func set(name: UserDefaultsName, string: Double) {
        UserDefaults.standard.set(string, forKey: name.rawValue)
    }
    
    public func double(by name: UserDefaultsName) -> Double {
        UserDefaults.standard.double(forKey: name.rawValue)
    }
}

public extension UserDefaults {
    static var appDefaults: AppDefaults {
        AppDefaults.shared
    }
}
