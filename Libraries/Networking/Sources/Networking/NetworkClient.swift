//
//  File.swift
//  
//
//  Created by Astemir Shibzuhov on 18.09.2024.
//

import Foundation

public enum HTTPMethod {
    case get
    case post
    
    var method: String {
        switch self {
        case .get: "GET"
        case .post: "POST"
        }
    }
}

public enum RequestServiceHTTPParams {
    case query([String: String])//, json(Decodable), jsonDictionary([String: Any])
}

public protocol NetworkClient {
    func performRequest(url: URL, method: HTTPMethod, path: [String], needLogCurl: Bool, params: RequestServiceHTTPParams, headers: [String: String], body: HTTPData?, completion: @escaping (Result<Data, Error>) -> Void)
}

public final class URLSessionNetworkClient: NetworkClient {
    public static var shared = URLSessionNetworkClient()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(url: URL,
                                      method: HTTPMethod,
                                      path: [String],
                                      needLogCurl: Bool,
                                      params: RequestServiceHTTPParams,
                                      headers: [String: String],
                                      body: HTTPData?,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(url: url,
                       method: method,
                       path: path,
                       needLogCurl: needLogCurl,
                       params: params,
                       headers: headers,
                       body: body) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(NSError(domain: "JSON DECODE ERROR", code: -1)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func performRequest(url: URL, method: HTTPMethod, path: [String], needLogCurl: Bool, params: RequestServiceHTTPParams, headers: [String: String], body: HTTPData?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        urlComponents.path += path.joined(separator: "/")
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
    
        request.httpMethod = method.method
        request.allHTTPHeaderFields = headers
        if let body {
            switch body {
            case .formData(let dictionary):
                let formData = MultipartFormData.createFormData(from: dictionary)
                request.allHTTPHeaderFields?["Content-Type"] = formData.contentType
                request.httpBody = formData.data
            case .data(let data):
                request.httpBody = data
            case .json(let model):
                request.allHTTPHeaderFields?["Content-Type"] = "application/json"

                let encoder = JSONEncoder()
                let data = try? encoder.encode(model)
                request.httpBody = data
            case .jsonDict(let dict):
                request.allHTTPHeaderFields?["Content-Type"] = "application/json"
                let seriolized = try? JSONSerialization.data(withJSONObject: dict)
                request.httpBody = seriolized
            }
        }
        
        if needLogCurl {
            print(request.curlString())
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if (response as? HTTPURLResponse)?.statusCode == 401 {
                completion(.failure(CoreError.unauthorized))
                return
            }
            
            guard let data = data else {
                if (response as? HTTPURLResponse)?.statusCode == 200 || (response as? HTTPURLResponse)?.statusCode == 201 {
                    completion(.success(Data()))
                    return
                }
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            if let respone = String(data: data, encoding: .utf8), needLogCurl {
                print(respone)
            }
            completion(.success(data))
        }
        
        task.resume()

    }
}

extension URLRequest {
    func curlString() -> String {
        var command = "curl"

        // URL
        guard let url = self.url else { return command }
        command += " '\(url.absoluteString)'"

        // HTTP Method
        if let method = self.httpMethod, method != "GET" {
            command += " -X \(method)"
        }

        // Headers
        if let headers = self.allHTTPHeaderFields {
            for (header, value) in headers {
                command += " -H '\(header): \(value)'"
            }
        }

        // Body
        if let httpBody = self.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            command += " --data '\(bodyString)'"
        }

        return command
    }

    func printCurl() {
        print(self.curlString())
    }
}
