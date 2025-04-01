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
    func setLocation(locationName: String)
}

protocol WeatherWidgetViewOutput {
    func viewDidLoad()
    func refereshData()
}

protocol WeatherWidgetModuleOutput: WidgetOutput {

}


struct WeatherWidgetState {
    let locationName: String
    let data: WeatherData
}

struct WeatherWidgetModel {
    let temperature: Double
    let windSpeed: Double
    let code: WeatherCode
    let currentHourIndex: Int
    let hourly: [HourlyWeather]
}

final class WeatherWidgetPresenter {
    weak var view: WeatherWidgetViewInput?
    weak var moduleOutput: WeatherWidgetModuleOutput?
    
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
        locationManager.getGeoInfo(from: .init(latitude: lat, longitude: lon)).sink { [weak self] geoInfo in
            self?.view?.setLocation(locationName: geoInfo.city)
        }
        .store(in: &cancellables)
        
        
        weatherService.requestHourlyForecast(lat: lat, lng: lon)
            .sink(receiveError: { [weak self] _ in
                self?.view?.setState(.error)
                self?.widgetOutput?.endRefresh(widget: .weather)
            }, receiveValue: { [weak self] hourly in
                self?.handleWeatherHourly(hourly)
            })
            .store(in: &cancellables)
    }
    
    private func handleWeatherHourly(_ model: WeatherHourly) {
        let calendar = Calendar.current

        if let currentWeatherIndex = model.hourly.firstIndex(where: {
            calendar.component(.hour, from: $0.date) == calendar.component(.hour, from: Date())
        }) {
            let currentWeather = model.hourly[currentWeatherIndex]
            let model = WeatherWidgetModel(temperature: currentWeather.temperature2m,
                                           windSpeed: currentWeather.windSpeed10m,
                                           code: currentWeather.weatherCode,
                                           currentHourIndex: currentWeatherIndex,
                                           hourly: model.hourly)
            view?.setState(.loaded(data: model))
        } else {
            self.view?.setState(.error)
        }
        
        moduleOutput?.widgetIsLoaded(widgetType: .weather)
        self.widgetOutput?.endRefresh(widget: .weather)
    }
}

extension WeatherWidgetPresenter: WeatherWidgetViewOutput {

    func viewDidLoad() {
        self.view?.setState(.loading)
        locationManager.delegate = self
        locationManager.start(.authorizedAlways)
    }
    
    func refereshData() {
        needRequest = true
        locationManager.start(.authorizedAlways)
    }
    
}

extension WeatherWidgetPresenter: LocationManagerDelegate {
    func didUpdateLocation(location: GeoInfo, totalAccuracy: Double) {
    }
    
    func didChangeAuthorization(status: CLAuthorizationStatus) {
        
    }
    
    func didUpdateLocation(latitude: Double, longitude: Double, totalAccuracy: Double) {
        if totalAccuracy <= 20, needRequest {
            needRequest = false
            self.locationManager.stop()
            request(lon: longitude, lat: latitude)
        }
    }
    
    func didFailWithError(error: any Error) {
        
    }
}

extension WeatherWidgetPresenter: WidgetInput {
    func refresh() {
        refereshData()
    }
}
