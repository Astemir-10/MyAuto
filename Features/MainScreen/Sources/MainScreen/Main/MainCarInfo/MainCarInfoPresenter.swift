//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 01.03.2025.
//

import Foundation

protocol MainCarInfoViewOutput {
    func viewDidLoad()
    func openDetailsCarInfo()
}

protocol MainCarInfoViewInput: AnyObject {
    func updateMainCarInfo(with model: MainCarInfoModel)
}

final class MainCarInfoPresenter: MainCarInfoViewOutput {
    weak var view: MainCarInfoViewInput?
    
    init(view: MainCarInfoViewInput) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.updateMainCarInfo(with: .init(brand: "Toyota",
                                            model: "Camry",
                                            year: 2016,
                                            licensePlate: "Н558ММ07",
                                            mileage: 146000000,
                                            fuelType: "Бензин",
                                            lastMaintenanceDate: "14.23.23",
                                            maintenanceStatus: .good,
                                            enginePower: 181,
                                            engineVolume: 2.5,
                                            carColor: "Белый",
                                            fuelTankCapacity: 70,
                                            configuration: "Exclusive",
                                            image: .getFromResources(by: "camry1"),
                                            logo: .getFromResources(by: "logoToyota"),
                                            fuelEconomy: 10,
                                            maxSpeed: 220,
                                            accelerationTime: 10.4))
    }
    
    func openDetailsCarInfo() {
        
    }
}
