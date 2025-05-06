//
//  File.swift
//  Profile
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import CarInfo
import CombineCoreData
import Architecture
import Combine
import Extensions
import AppKeychain
import AppServices
import UserDefaultsExtensions

protocol ProfileViewInput: AnyObject {
    func setData(carInfoDetailsModel: CarInfoDetailsModel)
}

protocol ProfileViewOutput {
    func viewDidLoad()
    func didTapAddButton()
    func didTapLogout()
}

final class ProfilePresenter: ProfileViewOutput {
    weak var view: ProfileViewInput?
    
    private let router: ProfileRouterInput
    private let storageService: CombineCoreData
    private var cancellables = Set<AnyCancellable>()
    private let keychain: AppKeychain
    private let authService: AuthorizationService
    
    init(keychain: AppKeychain, authService: AuthorizationService, storageService: CombineCoreData, view: ProfileViewInput, router: ProfileRouterInput) {
        self.view = view
        self.router = router
        self.storageService = storageService
        self.authService = authService
        self.keychain = keychain
    }
    
    func viewDidLoad() {
        storageService.fetchEntities(entity: CarInfo.self)
            .sink(receiveError: { error in
                print("OKOKOK")
                print(error.localizedDescription)
            }, receiveValue: { [weak self] carInfo in
                guard let self, let carModel = carInfo.first else {
                    return
                }
                DispatchQueue.main.async {
                    self.view?.setData(carInfoDetailsModel: CarInfoDetailsModel(carInfo: carModel))
                }

            })
            .store(in: &cancellables)

    }
    
    func didTapAddButton() {
        router.routeToCarInfoViewController(output: self)
    }
    
    func didTapLogout() {

        guard let userId = UserDefaults.appDefaults.string(by: .userId), userId != "" else {
            return
        }
        authService.logout(userId: userId)
            .sink(receiveError: { _ in
                
            }, receiveValue: { [weak self] _ in
                guard let self else {
                    return
                }
                UserDefaults.appDefaults.set(name: .userId, string: "")
                keychain.remove(by: "refreshToken")
                keychain.remove(by: "accessToken")
                NotificationCenter.default.post(name: .init("updateAuth"), object: nil, userInfo: nil)

            })
            .store(in: &cancellables)
        
    }
}


extension ProfilePresenter: CarInfoModuleOutput {
    func didGetCarInfo(carInfoDetailsModel: CarInfoDetailsModel) {
        view?.setData(carInfoDetailsModel: carInfoDetailsModel)
        storageService.deleteEntities(entity: CarInfo.self)
            .map({ [weak self] _ in
                self?.storageService.createEntity(entity: CarInfo.self, configure: { carInfo in
                    carInfoDetailsModel.convert(carInfo)
                }) ?? .empty()
            })
            .sink(receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
}
