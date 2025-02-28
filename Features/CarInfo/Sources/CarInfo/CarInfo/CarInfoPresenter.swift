//
//  CarInfoPresenter.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import Foundation
import Architecture
import Combine
import DesignKit
import CombineCoreData

protocol CarInfoViewInput: AnyObject, ErrorViewInput, LoaderViewInput {

}

protocol CarInfoViewOutput: LifeCycleObserver {
    func searchCarInfo(by number: String)
    func enterManual()
}

final class CarInfoPresenter: CarInfoViewOutput {
    
    weak var view: CarInfoViewInput?
    
    weak var moduleOutput: CarInfoModuleOutput?
    private let router: CarInfoRouter
    private let carInfoManager: CarInfoManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(view: CarInfoViewInput, router: CarInfoRouter, carInfoManager: CarInfoManager) {
        self.view = view
        self.carInfoManager = carInfoManager
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
    
    func searchCarInfo(by number: String) {
        view?.showLoader()
        self.carInfoManager.getInfo(number: number.replacingOccurrences(of: " ", with: ""))
            .sink { [weak self] compleation in
                if case .failure(let error) = compleation {
                    print(error.localizedDescription)
                    self?.view?.showCommonAlertError()
                }
            } receiveValue: { [weak self] data in
                self?.view?.hideLoader()
                if self?.moduleOutput == nil {
                    self?.router.showCarInfoDetail(carInfo: data, carNumber: number.replacingOccurrences(of: " ", with: ""))
                } else {
                    let model = CarInfoDetailsModel(carData: data, number: number)
                    model.number = number.replacingOccurrences(of: " ", with: "")
                    self?.moduleOutput?.didGetCarInfo(carInfoDetailsModel: model)
                    self?.router.close()
                }
                    
            }
            .store(in: &cancellables)
    }
    
    func enterManual() {
        
        self.router.showCarInfoDetail(carInfo: nil, carNumber: nil)
    }
    
}
