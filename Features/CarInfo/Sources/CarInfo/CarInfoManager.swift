//
//  CarInfoManager.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 14.08.2024.
//

import Foundation
import AppServices
import Combine
import Networking
import Extensions

final class CarInfoManager {
    let service: DromCarInfoService
    private let availableRetryCount = 3
    private var currentRetry = 1
    
    init(service: DromCarInfoService) {
        self.service = service
    }
    
    func getInfo(number: String) -> AnyPublisher<CarInfoModel.CarData, Networking.CoreError> {
        service.getToken(number: number)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .flatMap { token in
                self.service.checkGibddCarInfo(token: token.token)
                    .flatMap({ response -> AnyPublisher<CarInfoModel.CarData, Networking.CoreError> in
                        if let data = response.carData {
                            return .just(data)
                        } else {
                            return .fail(error: .networkError)
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
