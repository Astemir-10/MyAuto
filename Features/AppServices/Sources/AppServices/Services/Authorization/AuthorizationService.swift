//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 01.05.2025.
//

import Foundation
import Networking
import SessionManager
import Combine
import Extensions

public struct AuthTokenResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let userId: String
}

public struct ConfirmResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
}

public struct RegisterModel: Encodable {
    public let login: String
    public let password: String
    public let loginType: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case password
        case loginType = "login_type"
    }
    
    public init(login: String, password: String, loginType: String) {
        self.login = login
        self.password = password
        self.loginType = loginType
    }
}

public struct LoginModel: Encodable {
    public let login: String
    public let password: String
    
    public init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}

public struct ConfirmModel: Encodable {
    public let userId: String
    public let confirmCode: String
    
    public init(userId: String, code: String) {
        self.userId = userId
        self.confirmCode = code
    }
}

public struct UserRegistrationResponse: Codable {
    public let userId: String
}

public protocol AuthorizationService {
    func registration(registrationModel: RegisterModel) -> AnyPublisher<UserRegistrationResponse, CoreError>
    func confirmationCode(confirmModel: ConfirmModel) -> AnyPublisher<ConfirmResponse, CoreError>
    func login(loginModel: LoginModel) -> AnyPublisher<AuthTokenResponse, CoreError>
    func logout(userId: String) -> AnyPublisher<Void, CoreError>
}

public final class AuthorizationServiceImpl: AuthorizationService {
    
    private let sessionManager: CombineSessionManager
    
    public init(sessionManager: CombineSessionManager) {
        self.sessionManager = sessionManager
    }
    
    public func registration(registrationModel: RegisterModel) -> AnyPublisher<UserRegistrationResponse, Networking.CoreError> {
        sessionManager.request(item: AuthorizationServiceRequestItem.register(registrationModel: registrationModel))
    }
    
    public func confirmationCode(confirmModel: ConfirmModel) -> AnyPublisher<ConfirmResponse, Networking.CoreError> {
        sessionManager.request(item: AuthorizationServiceRequestItem.confirmation(confirmModel: confirmModel))
    }
    
    public func login(loginModel: LoginModel) -> AnyPublisher<AuthTokenResponse, Networking.CoreError> {
        sessionManager.request(item: AuthorizationServiceRequestItem.login(loginModel: loginModel))
    }
    
    public func logout(userId: String) -> AnyPublisher<Void, Networking.CoreError> {
        sessionManager.request(item: AuthorizationServiceRequestItem.logout(userId: userId))
    }
}
extension AuthorizationServiceImpl {
    enum AuthorizationServiceRequestItem: RequestItem {
        case login(loginModel: LoginModel), register(registrationModel: RegisterModel)
        case logout(userId: String), confirmation(confirmModel: ConfirmModel)
        var url: URL {
            switch self {
            case .login:
                ApiUrl.url.appendApiPath(.auth, .login, needGateway: false)
            case .register:
                ApiUrl.url.appendApiPath(.auth, .registration, needGateway: false)
            case .logout:
                ApiUrl.url.appendApiPath(.auth, .logout, needGateway: false)
            case .confirmation:
                ApiUrl.url.appendApiPath(.auth, .confirm, needGateway: false)
            }
        }
        
        var cacheKey: String {
            switch self {
            case .login:
                "login"
            case .register:
                "register"
            case .logout:
                "logout"
            case .confirmation:
                "confirmation"
            }
        }
        
        var params: RequestServiceHTTPParams {
            .query([:])
        }
        
        var needLogCurl: Bool {
            return true
        }
        
        var jsonDecoder: JSONDecoder { JSONDecoder() }
        
        var body: HTTPData? {
            switch self {
           
            case .login(let loginModel):
                    .json(loginModel)
            case .register(let registerModel):
                    .json(registerModel)
            case .logout(let userId):
                    .jsonDict(["userId": userId])
            case .confirmation(let confirmModel):
                    .json(confirmModel)
            }
        }
        
        var method: HTTPMethod {
            return .post
        }
        
        var needExtractData: Bool { false }
    }
    
}
