//
//  WeatherWidgetPresenter.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import Foundation
import LocationManager
import AppServices
import CoreLocation
import Combine

protocol WeatherWidgetViewInput: WidgetViewInput {
    
}

protocol WeatherWidgetViewOutput {
    func viewDidLoad()
}

final class WeatherWidgetPresenter {
    weak var view: WeatherWidgetViewInput?
    
    private let weatherService: WeatherService
    private var locationManager: LocationManager
    private var needRequest = true
    private var cancellables = Set<AnyCancellable>()
    private weak var widgetOutput: WidgetOutput?
    
    init(locationManager: LocationManager, weatherService: WeatherService, widgetOutput: WidgetOutput?, view: WeatherWidgetViewInput) {
        self.view = view
        self.locationManager = locationManager
        self.weatherService = weatherService
        self.widgetOutput = widgetOutput
    }
    
    private func request(lon: Double, lat: Double) {
        guard needRequest else {
            return
        }
        weatherService.requestForecast(lat: lat, lng: lon)
            .sink (receiveError: { [weak self] error in
                self?.view?.setState(.error)
            }, receiveValue: { [weak self] data in
                self?.view?.setState(.loaded(data: data))
                self?.widgetOutput?.widgetIsLoaded(widgetType: .weather)
            })
            .store(in: &cancellables)

        needRequest = false
    }
}

extension WeatherWidgetPresenter: WeatherWidgetViewOutput {
    func viewDidLoad() {
        self.view?.setState(.loading)
        locationManager.delegate = self
        locationManager.start(.authorizedAlways)
    }
    
    
}

extension WeatherWidgetPresenter: LocationManagerDelegate {
    func didUpdateLocation(location: GeoInfo, totalAccuracy: Double) {
    }
    
    func didChangeAuthorization(status: CLAuthorizationStatus) {
        
    }
    
    func didUpdateLocation(latitude: Double, longitude: Double, totalAccuracy: Double) {
        if totalAccuracy <= 10 {
            self.locationManager.stop()
            request(lon: longitude, lat: latitude)
        }
    }
    
    func didFailWithError(error: any Error) {
        
    }
}
