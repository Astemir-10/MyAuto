//
//  CarInfoRouter.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import Foundation
import Architecture
import AppServices

final class CarInfoRouter: RouterInput {
    weak var transitionHandler: TransitionHandler!
    
    
    func showCarInfoDetail(carInfo: CarInfoModel.CarData?, carNumber: String?) {
        let viewControlelr = CarInfoDetailsAssembly.makeModule(carData: carInfo, carNumber: carNumber)
        transitionHandler.present(viewControlelr)
    }
}
