//
//  File 2.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import Foundation
import AppServices
import CombineCoreData
import CoreLocation
import Combine
import UserDefaultsExtensions

protocol PetrolsListViewInput: AnyObject {
    func setState(_ state: PetrolsListScreenState)
}

protocol PetrolsListViewOutput {
    func setup()
}

enum PetrolsListScreenState {
    case loading, loaded([PetrolExpense.PetrolStation]), error
}

final class PetrolsListPresenter {
    private weak var view: PetrolsListViewInput?
    private let petrolService: PetrolService
    private let storage: CombineCoreData
    private let userLocation: CLLocation?
    private let userRegion: String?
    private var cancellables = Set<AnyCancellable>()
    private var petrols = [PetrolExpense.PetrolStation]()
    
    
    init(view: PetrolsListViewInput, petrolService: PetrolService, storage: CombineCoreData) {
        self.view = view
        self.petrolService = petrolService
        self.storage = storage
        let longitude = UserDefaults.appDefaults.double(by: .userLongitude)
        let latitude =  UserDefaults.appDefaults.double(by: .userLatitude)
        if longitude != 0 && latitude != 0 {
            userLocation = .init(latitude: latitude, longitude: longitude)
        } else {
            self.userLocation = nil
        }
        if let userRegion = UserDefaults.appDefaults.string(by: .userRegion) {
            self.userRegion = userRegion
        } else {
            self.userRegion = nil
        }
    }
    
}

extension PetrolsListPresenter: PetrolsListViewOutput {
    func setup() {
        if let userRegion {
            petrolService.cachedOrRequestedPricesInfo(region: userRegion)
                .sink { error in
                    
                } receiveValue: { [weak self] response in
                    self?.petrols = response.stations.map({
                        var types = [PetrolExpense.PetrolTypeItem]()
                        if let ai92 = $0.ai92 {
                            types.append(.init(petrolType: .ai92, priceOnLiter: ai92))
                        }
                        if let ai95 = $0.ai95 {
                            types.append(.init(petrolType: .ai95, priceOnLiter: ai95))
                        }
                        if let ai100 = $0.ai100 {
                            types.append(.init(petrolType: .ai100, priceOnLiter: ai100))
                        }
                        if let gas = $0.gas {
                            types.append(.init(petrolType: .gas, priceOnLiter: gas))
                        }
                        
                        if let dt = $0.dt {
                            types.append(.init(petrolType: .disel, priceOnLiter: dt))
                        }
                        
                        return PetrolExpense.PetrolStation(name: $0.name,
                                                           cityName: $0.cityName,
                                                           petrolTypes: types,
                                                           longitude: $0.longitude ?? 0,
                                                           latitude: $0.latitude ?? 0)
                    })
                    guard let petrols = self?.petrols else { return }
                    self?.view?.setState(.loaded(petrols))
                }
                .store(in: &cancellables)

        }
    }
}
