//
//  RequestService.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 14.08.2024.
//

import Foundation

class RequestService {
    enum RequestServiceHTTPMethod: String {
        case get = "GET"
        case post = "POST"
        
    }
    
    enum RequestServiceHTTPError: Error {
        case responseError, dataError
    }
    
    enum RequestServiceHTTPParams {
        case query([String: String])
    }
    
    private let session: URLSession = .shared
    
    func request(url: URL, params: RequestServiceHTTPParams = .query([:]), headers: [String: String] = [:], httpMethod: RequestServiceHTTPMethod = .get, body: Data? = nil, responseHandler: @escaping (Result<Data, RequestServiceHTTPError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        var query = urlComponents.queryItems ?? []
        switch params {
        case .query(let dictionary):
            dictionary.forEach({
                query.append(.init(name: $0.key, value: $0.value))
            })
        }
        urlComponents.queryItems = query
        
        guard let url = urlComponents.url else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                responseHandler(.failure(.responseError))
                return
            }
            guard let data else {
                responseHandler(.failure(.dataError))
                return
            }
            responseHandler(.success(data))
        }.resume()
    }
}
