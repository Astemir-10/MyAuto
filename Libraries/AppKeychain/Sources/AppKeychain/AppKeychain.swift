import Foundation
import KeychainAccess

public protocol AppKeychain {
    func set(_ value: String, by key: String)
    func get(by key: String) -> String?
    func remove(by key: String)
}

public final class AppKeychainImpl: AppKeychain {
    private let keychain: Keychain
    
    public init(service: String, accessGroup: String? = nil) {
        if let accessGroup {
            self.keychain = .init(service: service, accessGroup: accessGroup)
        } else {
            self.keychain = .init(service: service)
        }
    }
    
    public func set(_ value: String, by key: String) {
        do {
            try keychain.set(value, key: key)
        } catch {
            print("Error save keychain by key \(key)")
        }
    }
    
    public func get(by key: String) -> String? {
        do {
            return try keychain.get(key)
        } catch {
            print("Error get value from keychain by key \(key)")
            return nil
        }
    }
    
    public func remove(by key: String) {
        do {
            try keychain.remove(key)
        } catch {
            print("Error removing from keychain by key \(key)")
        }
    }
}

