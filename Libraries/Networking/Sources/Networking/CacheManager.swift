//
//  File 2.swift
//  
//
//  Created by Astemir Shibzuhov on 18.09.2024.
//

import Foundation
import UIKit

protocol Cache {
    func getCachedResponse(by key: String) -> Data?
    func saveResponse(_ data: Data, by key: String)
}

final class MemoryCache: Cache {
    private let tempCache = TempCache()
    
    func getCachedResponse(by key: String) -> Data? {
        return tempCache.loadData(forKey: key)
    }
    
    func saveResponse(_ data: Data, by key: String) {
        tempCache.saveData(data, forKey: key)
    }
}

public extension UIApplication {
    static func cleanCache() {
        let tempCache = TempCache()
        tempCache.clearCache()
    }
}
