//
//  File.swift
//  
//
//  Created by Astemir Shibzuhov on 18.09.2024.
//

import Foundation
import Combine

public enum CachePolicy {
    case cacheEnabled
}

public enum HTTPData {
    case formData([String: String?]), data(Data)
}

public protocol RequestItem {
    var url: URL { get }
    var headers: [String: String] { get }
    var cachePolicy: CachePolicy { get }
    var method: HTTPMethod { get }
    var body: HTTPData? { get }
    var params: RequestServiceHTTPParams { get }
    var cacheKey: String { get }
    var path: [String] { get }
    var jsonDecoder: JSONDecoder { get }
    var needLogCurl: Bool { get }
    var needExtractData: Bool { get }
}

public extension RequestItem {
    var headers: [String: String] { [:] }
    var cachePolicy: CachePolicy { .cacheEnabled }
    var method: HTTPMethod { .get }
    var body: HTTPData? { nil }
    var params: RequestServiceHTTPParams { .query([:]) }
    var path: [String] { [] }
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    var needLogCurl: Bool { false }
    
    var needExtractData: Bool { true }
}

public enum CoreError: Error {
    case networkError
    case decodeError
    case serverError(status: Int, message: String?)
}

enum DataExtracter {
    static func extract(data: Data) -> Result<Data, CoreError> {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            if let data = json?["data"] as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: data)
                return .success(data)
            } else if let status = json?["status"] as? Int, let error = json?["error"] as? String {
                return .failure(.serverError(status: status, message: error))
            } else {
                return .failure(.decodeError)
            }
        } catch {
            return .failure(.decodeError)
        }
    }
}

open class CombineSessionManager {
    private let client: NetworkClient = URLSessionNetworkClient.shared
    
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
                    promise(.success(data))
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

open class CombineCachedSessionManager {
    private let client: NetworkClient = URLSessionNetworkClient.shared
    private let cache = MemoryCache()
    
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
                        print("Error Decoding by url: \(item.url.absoluteString)")
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
    
    public init() {
        
    }
}
