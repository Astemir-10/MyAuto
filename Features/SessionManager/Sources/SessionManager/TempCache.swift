//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import Foundation

class TempCache {
    private let cacheDirectory: URL
    private let fileManager = FileManager.default
    
    init() {
        // Определим директорию для временных файлов в Cache Directory
        cacheDirectory = fileManager.temporaryDirectory.appendingPathComponent("AppCache", isDirectory: true)
        
        // Удалим старое содержимое при каждом новом запуске
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func saveData(_ data: Data, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? data.write(to: fileURL)
    }
    
    func loadData(forKey key: String) -> Data? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        return try? Data(contentsOf: fileURL)
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
    }
}

