//
//  File.swift
//  
//
//  Created by Astemir Shibzuhov on 18.09.2024.
//

import Foundation
import Combine
import Networking
import AppKeychain

struct AccesToken: Codable {
    let accessToken: String
    let refreshToken: String
}

final class AuthManager {
    enum KeychainKey: String {
        case accessToken
        case refreshToken
    }
    private let keychain: AppKeychain = AppKeychainImpl(service: "com.myauto.MyAuto")
    private let client: NetworkClient = URLSessionNetworkClient.shared
    
    
    func handleResponse(item: RequestItem, completion: @escaping (Result<Data, Error>) -> ()) {
        
        refreshToken { [weak self] result in
            switch result {
            case .success(let success):
                self?.keychain.set(success.accessToken, by: KeychainKey.accessToken.rawValue)
                self?.keychain.set(success.refreshToken, by: KeychainKey.refreshToken.rawValue)
                let headers = self?.setHeaders(headers: item.headers)
                switch headers {
                case .success(let success):
                    self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: success, body: item.body, completion: completion)
                case .failure(let failure):
                    completion(.failure(failure))
                case .none:
                    completion(.failure(CoreError.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    func setHeaders(headers: [String: String]) -> Result<[String: String], Error> {
        guard let accessToken = keychain.get(by: KeychainKey.accessToken.rawValue) else {
            return .failure(CoreError.notFoundAccessTokenSaved)
        }
        var headers = headers
        headers["Authorization"] = "Bearer \(accessToken)"
        return .success(headers)
    }
    
    private func refreshToken( completion: @escaping (Result<AccesToken, Error>) -> ()) {
        guard let url = URL(string: "https://api.car-mate.ru/auth/refreshToken") else {
            completion(.failure(CoreError.badUrlRefreshToken))
            return
        }
                       
        guard let refreshToken = keychain.get(by: KeychainKey.refreshToken.rawValue) else {
            completion(.failure(CoreError.noFoundRefreshTokenSaved))
            return
        }
        
        client.performRequest(url: url,
                              method: .post,
                              path: [],
                              needLogCurl: true,
                              params: .query([:]),
                              headers: ["Content-Type": "application/json"],
                              body: .jsonDict(["refreshToken": refreshToken])) { result in
            let decoder = JSONDecoder()
            
            switch result {
            case .success(let success):
                do {
                    let decoded = try decoder.decode(AccesToken.self, from: success)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        }
    }
}

open class CombineSessionManager {
    private let client: NetworkClient = URLSessionNetworkClient.shared
    private let authManager = AuthManager()
    
    public final func request<T: Decodable>(item: RequestItem) -> AnyPublisher<T, CoreError> {
        Future { [weak self] promise in
            let headersResult = self?.authManager.setHeaders(headers: item.headers)
            var header = item.headers
            switch headersResult {
            case .success(let success):
                if !item.url.absoluteString.contains("auth") {
                    header = success
                }
            case .failure:
                if !item.url.absoluteString.contains("auth") {
                    promise(.failure(.networkError))
                }
            case .none:
                if !item.url.absoluteString.contains("auth") {
                    promise(.failure(.networkError))
                }
            }
            
            self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: header, body: item.body) { result in
                switch result {
                case .success(let data):
                    print("SUCCESS")
                    do {
                        if item.needExtractData {
                            let extractedData = DataExtracter.extract(data: data)
                            switch extractedData {
                            case .success(let data):
                                let model = try item.jsonDecoder.decode(T.self, from: data)
                                promise(.success(model))
                            case .failure(let failure):
                                print("Error Decoding by url: \(item.url.absoluteString)")
                                promise(.failure(failure))
                            }
                        } else {
                            let model = try item.jsonDecoder.decode(T.self, from: data)
                            promise(.success(model))
                        }
                    } catch {
                        print("Error Decoding by url: \(item.url.absoluteString)")
                        promise(.failure(.networkError))
                    }
                case .failure(let error):
                    print("FILURE")
                    if (error as? CoreError) == .unauthorized && !item.url.absoluteString.contains("auth") {
                        self?.authManager.handleResponse(item: item, completion: { result in
                            switch result {
                            case .success(let data):
                                do {
                                    if item.needExtractData {
                                        let extractedData = DataExtracter.extract(data: data)
                                        switch extractedData {
                                        case .success(let data):
                                            let model = try item.jsonDecoder.decode(T.self, from: data)
                                            promise(.success(model))
                                        case .failure(let failure):
                                            print("Error Decoding by url: \(item.url.absoluteString)")
                                            promise(.failure(failure))
                                        }
                                    } else {
                                        let model = try item.jsonDecoder.decode(T.self, from: data)
                                        promise(.success(model))
                                    }
                                } catch {
                                    print("Error Decoding by url: \(item.url.absoluteString)")
                                    promise(.failure(.networkError))
                                }
                            case .failure:
                                break
                            }
                        })
                    } else {
                        promise(.failure(.networkError))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public final func request(item: RequestItem) -> AnyPublisher<Data, CoreError> {
        Future { [weak self] promise in
            let headersResult = self?.authManager.setHeaders(headers: item.headers)
            var header = item.headers
            switch headersResult {
            case .success(let success):
                if !item.url.absoluteString.contains("auth") {
                    header = success
                }
            case .failure:
                if !item.url.absoluteString.contains("auth") {
                    promise(.failure(.networkError))
                }
            case .none:
                if !item.url.absoluteString.contains("auth") {
                    promise(.failure(.networkError))
                }
            }

            self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: header, body: item.body) { result in
                switch result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    if (error as? CoreError) == .unauthorized && !item.url.absoluteString.contains("auth") {
                        self?.authManager.handleResponse(item: item, completion: { result in
                            switch result {
                            case .success(let data):
                                promise(.success(data))
                            case .failure:
                                promise(.failure(.networkError))
                            }
                        })
                    } else {
                        promise(.failure(.networkError))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public final func request(item: RequestItem) -> AnyPublisher<Void, CoreError> {
        
        Future { [weak self] promise in
            let headersResult = self?.authManager.setHeaders(headers: item.headers)
            var header = item.headers
            switch headersResult {
            case .success(let success):
                if !item.url.absoluteString.contains("auth") {
                    header = success
                }
            case .failure:
                if !item.url.absoluteString.contains("auth") {
                    promise(.failure(.networkError))
                }
            case .none:
                if !item.url.absoluteString.contains("auth") {
                    promise(.failure(.networkError))
                }
            }

            self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: header, body: item.body) { result in
                switch result {
                case .success:
                    promise(.success(Void()))
                case .failure(let error):
                    if (error as? CoreError) == .unauthorized && !item.url.absoluteString.contains("auth") {
                        self?.authManager.handleResponse(item: item, completion: { result in
                            switch result {
                            case .success:
                                promise(.success(Void()))
                            case .failure:
                                promise(.failure(.networkError))
                            }
                        })
                    } else {
                        promise(.failure(.networkError))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public init() {
        
    }
}

public class CombineCachedSessionManager {
    private let client: NetworkClient = URLSessionNetworkClient.shared
    private let cache = MemoryCache()
    private let authManager = AuthManager()
    
    public final func cachedOrRequested<T: Decodable>(item: RequestItem) -> AnyPublisher<T, CoreError> {
        Future { [weak self] promise in
            
            if let cachedData = self?.cache.getCachedResponse(by: item.cacheKey) {
                do {
                    let model = try item.jsonDecoder.decode(T.self, from: cachedData)
                    promise(.success(model))
                } catch {
                    print("Error Decoding by url from cache by cache key \(item.cacheKey): \(item.url.absoluteString)")
                    promise(.failure(.networkError))
                }
                return
            }
            
            self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: item.headers, body: item.body) { result in
                switch result {
                case .success(let data):
                    do {
                        if item.needExtractData {
                            let extractedData = DataExtracter.extract(data: data)
                            switch extractedData {
                            case .success(let data):
                                self?.cache.saveResponse(data, by: item.cacheKey)
                                let model = try item.jsonDecoder.decode(T.self, from: data)
                                promise(.success(model))
                            case .failure(let failure):
                                print("Error Decoding by url: \(item.url.absoluteString)")
                                promise(.failure(failure))
                            }
                        } else {
                            self?.cache.saveResponse(data, by: item.cacheKey)
                            let model = try item.jsonDecoder.decode(T.self, from: data)
                            promise(.success(model))

                        }
                    } catch {
                        print("Error Decoding by url: \(item.url.absoluteString)")
                        promise(.failure(.networkError))
                    }
                case .failure:
                promise(.failure(.networkError))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public final func request<T: Decodable>(item: RequestItem) -> AnyPublisher<T, CoreError> {
        Future { [weak self] promise in
            self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: item.headers, body: item.body) { result in
                switch result {
                case .success(let data):
                    do {
                        if item.needExtractData {
                            let extractedData = DataExtracter.extract(data: data)
                            switch extractedData {
                            case .success(let data):
                                self?.cache.saveResponse(data, by: item.cacheKey)
                                let model = try item.jsonDecoder.decode(T.self, from: data)
                                promise(.success(model))
                            case .failure(let failure):
                                print("Error Decoding by url: \(item.url.absoluteString)")
                                print(String(data: data, encoding: .utf8)!)
                                promise(.failure(failure))
                            }
                        } else {
                            self?.cache.saveResponse(data, by: item.cacheKey)
                            let model = try item.jsonDecoder.decode(T.self, from: data)
                            promise(.success(model))
                        }
                        
                    } catch {
                        print("Error Decoding by url lolol: \(item.url.absoluteString)")
                        print(String(data: data, encoding: .utf8)!)
                        promise(.failure(.networkError))
                    }
                case .failure:
                promise(.failure(.networkError))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public final func request(item: RequestItem) -> AnyPublisher<Data, CoreError> {
        Future { [weak self] promise in
            self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: item.headers, body: item.body) { result in
                switch result {
                case .success(let data):
                    self?.cache.saveResponse(data, by: item.cacheKey)
                    promise(.success(data))
                case .failure:
                    promise(.failure(.networkError))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public final func request(item: RequestItem) -> AnyPublisher<Void, CoreError> {
        Future { [weak self] promise in
            self?.client.performRequest(url: item.url, method: item.method, path: item.path, needLogCurl: item.needLogCurl, params: item.params, headers: item.headers, body: item.body) { result in
                switch result {
                case .success(let data):
                    self?.cache.saveResponse(data, by: item.cacheKey)
                    promise(.success(Void()))
                case .failure:
                    promise(.failure(.networkError))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    public init() {
        
    }
}
