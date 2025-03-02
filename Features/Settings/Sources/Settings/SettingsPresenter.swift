//
//  File.swift
//  Settings
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import CarInfo
import CombineCoreData
import Architecture
import Combine
import Extensions

protocol SettingsViewInput: AnyObject {
    func setData(carInfoDetailsModel: CarInfoDetailsModel)
}

protocol SettingsViewOutput {
    func viewDidLoad()
    func didTapAddButton()
}

final class SettingsPresenter: SettingsViewOutput {
    weak var view: SettingsViewInput?
    
    private let router: SettingsRouterInput
    private let storageService: CombineCoreData
    private var cancellables = Set<AnyCancellable>()
    
    init(storageService: CombineCoreData, view: SettingsViewInput, router: SettingsRouterInput) {
        self.view = view
        self.router = router
        self.storageService = storageService
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
}


extension SettingsPresenter: CarInfoModuleOutput {
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
