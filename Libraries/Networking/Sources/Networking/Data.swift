//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import Foundation

public enum CachePolicy {
    case cacheEnabled
}

public enum HTTPData {
    case formData([String: String?]), data(Data), json(Encodable), jsonDict([String: Any])
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

public enum CoreError: Error, Equatable {
    case networkError
    case unauthorized
    case badUrlRefreshToken
    case noFoundRefreshTokenSaved
    case notFoundAccessTokenSaved
    case decodeError
    case serverError(status: Int, message: String?)
}



public enum DataExtracter {
    public static func extract(data: Data) -> Result<Data, CoreError> {
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
