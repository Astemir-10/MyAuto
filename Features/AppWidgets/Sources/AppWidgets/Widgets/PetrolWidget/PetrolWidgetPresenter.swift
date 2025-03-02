//
//  PetrolWidgetPresenter.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 03.11.2024.
//

import UIKit
import AppServices
import Combine
import LocationManager
import CoreLocation
import Extensions
import Networking
import MapKit
import AppMap

protocol PetrolWidgetViewInput: WidgetViewInput {
    
}

protocol PetrolWidgetViewOutput {
    func viewDidLoad()
    func didTapLocation(item: PetrolWidgetInfoModel)
    func didTapPetrol(item: PetrolWidgetInfoModel)
}

public struct PetrolWidgetInfoModel {
    public let id: UUID = UUID()
    public let name: String?
    public let regionName: String?
    public let cityName: String?
    public let petrolType: PetrolItemModel.PetrolType?
    public let image: UIImage?
    public let ai92: Double?
    public let ai95: Double?
    public let ai100: Double?
    public let gas: Double?
    public let dt: Double?
    public let longitude: Double
    public let latitude: Double
    
    init(name: String?, image: UIImage?, regionName: String?, cityName: String?, ai92: Double?, ai95: Double?, ai100: Double?, gas: Double?, dt: Double?, longitude: Double, latitude: Double, petrolType: PetrolItemModel.PetrolType?) {
        self.name = name
        self.image = image
        self.ai92 = ai92
        self.ai95 = ai95
        self.ai100 = ai100
        self.gas = gas
        self.regionName = regionName
        self.cityName = cityName
        self.dt = dt
        self.longitude = longitude
        self.latitude = latitude
        self.petrolType = petrolType
    }
    
    init(_ item: PetrolItemModel, longitude: Double, latitude: Double) {
        self.name = item.petrol?.name
        self.ai92 = item.ai92
        self.ai95 = item.ai95
        self.ai100 = item.ai100
        self.gas = item.gas
        self.dt = item.dt
        self.longitude = longitude
        self.latitude = latitude
        self.petrolType = item.petrol
        self.regionName = item.regionName
        self.cityName = item.cityName
        if let petrol = item.petrol {
            
            switch petrol {
            case .gazpromneft:
                image = .appImages.brands.gazpromneft
            case .lukoil:
                image = .appImages.brands.lukoil
            case .rosneft:
                image = .appImages.brands.rosneft
            }
        } else {
            image = nil
        }
        
    }
    
    init(_ item: PetrolItemModel) {
        self.name = item.petrol?.name
        self.ai92 = item.ai92
        self.ai95 = item.ai95
        self.ai100 = item.ai100
        self.gas = item.gas
        self.dt = item.dt
        self.longitude = item.longitude ?? 0
        self.latitude = item.latitude ?? 0
        self.petrolType = item.petrol
        self.regionName = item.regionName
        self.cityName = item.cityName
        if let petrol = item.petrol {
            
            switch petrol {
            case .gazpromneft:
                image = .appImages.brands.gazpromneft
            case .lukoil:
                image = .appImages.brands.lukoil
            case .rosneft:
                image = .appImages.brands.rosneft
            }
        } else {
            image = nil
        }
        
    }

}

struct PetrolWidgetModel {
    let petrols: [PetrolWidgetInfoModel]
}

final class PetrolWidgetPresenter {
    weak var view: PetrolWidgetViewInput?
    private let petrolService: PetrolService
    private let geocoderService: GeocoderService
    private let router: PetrolWidgetRouter
    private weak var moduleOutput: PetrolWidgetModuleOutput?
    
    private var cancellables = Set<AnyCancellable>()
    private var locationManager: LocationManager
    private var needRequestPetrol = true
    private var petrolWidget: PetrolWidgetModel?
    private var items: [PetrolWidgetInfoModel] = []
    private var currentRegion: String?
    private weak var widgetOutput: WidgetOutput?
    
    init(petrolService: PetrolService, geocoderService: GeocoderService, widgetOutput: WidgetOutput?, locationManager: LocationManager, view: any PetrolWidgetViewInput, moduleOutput: PetrolWidgetModuleOutput, router: PetrolWidgetRouter) {
        self.view = view
        self.petrolService = petrolService
        self.geocoderService = geocoderService
        self.locationManager = locationManager
        self.moduleOutput = moduleOutput
        self.router = router
        self.widgetOutput = widgetOutput
    }
    
    private func requests(geoInfo: GeoInfo) {
        guard needRequestPetrol else { return }
        needRequestPetrol = false

        petrolService.cachedOrRequestedRegions()
            .flatMap({ [weak self] regions -> AnyPublisher<String, CoreError> in
                guard let self = self,
                      let regionCode = regions.regions.first(where: { $0.value.lowercased() == geoInfo.region.lowercased() })?.id else {
                    return .fail(error: .networkError)
                }
                self.currentRegion = regionCode
                return Just(regionCode).setFailureType(to: CoreError.self).eraseToAnyPublisher()
            })
            .flatMap({ [weak self] regionCode -> AnyPublisher<[PetrolItemModel], CoreError> in
                guard let self = self, regionCode != "" else { return .empty() }
                return petrolService.cachedOrRequestedPricesInfo(region: regionCode)
                    .map({ $0.stations })
                    .eraseToAnyPublisher()
            })
            .sink(receiveError: { [weak self] error in
                self?.view?.setState(.error)
            }, receiveValue: { [weak self] petrols in
                self?.processPetrolModels(petrols, geoInfo: geoInfo)
            })
            .store(in: &self.cancellables)
    }
    
    private func processPetrolModels(_ petrolModels: [PetrolItemModel], geoInfo: GeoInfo) {
        let currentLocation = CLLocationCoordinate2D(latitude: geoInfo.latitude, longitude: geoInfo.longitude)
        
        let allItems: [PetrolWidgetInfoModel] = petrolModels.filter({ $0.ai100 != nil || $0.ai92 != nil || $0.ai95 != nil || $0.gas != nil || $0.dt != nil }).map({ PetrolWidgetInfoModel.init($0) })
        var petrols: [PetrolWidgetInfoModel] = []
        
        if let lukoilModel = self.getPetrol(userLocation: currentLocation, petrols: allItems.filter({ $0.petrolType == .lukoil })) {
            petrols.append(lukoilModel)
        }
        
        if let rosneftModel = self.getPetrol(userLocation: currentLocation, petrols: allItems.filter({ $0.petrolType == .rosneft })) {
            petrols.append(rosneftModel)
        }
        
        if let gazpromModel = self.getPetrol(userLocation: currentLocation, petrols: allItems.filter({ $0.petrolType == .gazpromneft })) {
            petrols.append(gazpromModel)
        }
        
        self.petrolWidget = PetrolWidgetModel(petrols: petrols)
        if let petrolWidget = self.petrolWidget {
            self.view?.setState(.loaded(data: petrolWidget))
            self.widgetOutput?.widgetIsLoaded(widgetType: .petrol)
        }
        self.items = allItems
    }
    
    private func getPetrol(userLocation: CLLocationCoordinate2D, petrols: [PetrolWidgetInfoModel]) -> PetrolWidgetInfoModel? {
        let coordinates = petrols.compactMap({
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        })
        
        guard let petrolLocation = self.locationManager.findClosestCoordinate(to: userLocation, from: coordinates), let petrolModel = petrols.first(where: {
            $0.latitude == petrolLocation.latitude && $0.longitude == petrolLocation.longitude
        }) else {
            return nil
        }
        
        return petrolModel
    }
    
}

extension PetrolWidgetPresenter: PetrolWidgetViewOutput {
    func didTapLocation(item: PetrolWidgetInfoModel) {
        let annotations = self.items.map({
            PetrolAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        })
        router.navigateToMap(annotations: annotations, current: PetrolAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)))
    }
    
    func didTapPetrol(item: PetrolWidgetInfoModel) {
        
    }
        
    func viewDidLoad() {
        self.view?.setState(.loading)
        self.locationManager.delegate = self
        locationManager.start(.authorizedAlways)
    }
}

extension PetrolWidgetPresenter: LocationManagerDelegate {
    func didUpdateLocation(location: GeoInfo, totalAccuracy: Double) {
        self.requests(geoInfo: location)
    }
    
    func didUpdateLocation(latitude: Double, longitude: Double, totalAccuracy: Double) {
        if totalAccuracy <= 10 {
            self.locationManager.stop()
        }
    }
    
    func didFailWithError(error: Error) {
        self.view?.setState(.error)
    }
    
    func didChangeAuthorization(status: CLAuthorizationStatus) {
        if status == .notDetermined || status == .denied {
            self.view?.setState(.error)
        }
    }
}
