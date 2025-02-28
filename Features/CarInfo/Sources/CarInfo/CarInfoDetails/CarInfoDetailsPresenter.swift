//
//  CarInfoDetailsPresenter.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import Foundation
import Architecture
import AppServices
import CombineCoreData
import Combine
import DesignKit
import Extensions

protocol CarInfoDetailsViewInput: AnyObject, ErrorViewInput {
    func setModel(carModel: CarInfoDetailsModel)
}

protocol CarInfoDetailsViewOutput: LifeCycleObserver {
    func saveData()
}

final class CarInfoDetailsPresenter: CarInfoDetailsViewOutput {
    weak var view: CarInfoDetailsViewInput?
    private var carInfoDetailsModel: CarInfoDetailsModel
    private let coreDataService: CombineCoreData
    private var cancellables = Set<AnyCancellable>()
    
    
    init(carData: CarInfoModel.CarData?, carNumber: String?, view: CarInfoDetailsViewInput?, coreDataService: CombineCoreData) {
        self.view = view
        self.coreDataService = coreDataService
        if let carData {
            carInfoDetailsModel = .init(carData: carData, number: carNumber)
        } else {
            carInfoDetailsModel = .init()
        }
        
    }
    
    func viewDidLoad() {
        view?.setModel(carModel: self.carInfoDetailsModel)
        coreDataService.fetchEntities(entity: CarInfo.self)
            .sink(receiveValue: { carInfo in
                if let carInfo = carInfo.first {
                    print(carInfo.mark)
                    print(carInfo.color)
                    print(carInfo.mileage?.intValue)
                    print(carInfo.power?.intValue)
                    print(carInfo.volumeEngine?.doubleValue)
                }
            })
            .store(in: &cancellables)
    }
    
    func saveData() {
        coreDataService.fetchEntities(entity: CarInfo.self)
            .map({ ($0.isEmpty, $0) })
            .flatMap { [weak self] isEmpty, object in
                if isEmpty {
                    return self?.coreDataService.createEntity(entity: CarInfo.self) { object in
                        self?.carInfoDetailsModel.convert(object)
                    } ?? .empty()
                } else {
                    return self?.coreDataService.updateEntity(entity: object.first!) { object in
                        self?.carInfoDetailsModel.convert(object)
                    } ?? .empty()
                }
            }
            .sink(receiveError: { [weak self] error in
                print(error.localizedDescription)
                self?.view?.showCommonAlertError()
            })
            .store(in: &cancellables)
    }
}
