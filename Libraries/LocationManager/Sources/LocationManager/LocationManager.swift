//
//  LocationManager.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import Foundation
import CoreLocation
import Combine

public struct GeoInfo {
    public let region: String
    public let city: String
    public let country: String
    public let longitude: Double
    public let latitude: Double
    
    static var regionMapping: [String: String] { [
        // Автономная область
        "Еврейская АО": "Еврейская автономная область",
        
        // Автономные округа
        "Ненецкий АО": "Ненецкий автономный округ",
        "Ханты-Мансийский АО": "Ханты-Мансийский автономный округ — Югра",
        "Чукотский АО": "Чукотский автономный округ",
        "Ямало-Ненецкий АО": "Ямало-Ненецкий автономный округ",
        
        // Республики
        "Адыгея": "Республика Адыгея",
        "Алтай": "Республика Алтай",
        "Башкортостан": "Республика Башкортостан",
        "Бурятия": "Республика Бурятия",
        "Дагестан": "Республика Дагестан",
        "Ингушетия": "Республика Ингушетия",
        "Кабардино-Балкария": "Кабардино-Балкарская Республика",
        "Калмыкия": "Республика Калмыкия",
        "Карачаево-Черкесия": "Карачаево-Черкесская Республика",
        "Карелия": "Республика Карелия",
        "Коми": "Республика Коми",
        "Крым": "Республика Крым",
        "Марий Эл": "Республика Марий Эл",
        "Мордовия": "Республика Мордовия",
        "Саха (Якутия)": "Республика Саха (Якутия)",
        "Северная Осетия — Алания": "Республика Северная Осетия — Алания",
        "Татарстан": "Республика Татарстан",
        "Тыва": "Республика Тыва",
        "Удмуртия": "Удмуртская Республика",
        "Хакасия": "Республика Хакасия",
        "Чечня": "Чеченская Республика",
        "Чувашия": "Чувашская Республика",
        
        // Края
        "Алтайский край": "Алтайский край",
        "Забайкальский край": "Забайкальский край",
        "Камчатский край": "Камчатский край",
        "Краснодарский край": "Краснодарский край",
        "Красноярский край": "Красноярский край",
        "Пермский край": "Пермский край",
        "Приморский край": "Приморский край",
        "Ставропольский край": "Ставропольский край",
        "Хабаровский край": "Хабаровский край",
        
        // Города федерального значения
        "Москва": "Москва",
        "Санкт-Петербург": "Санкт-Петербург",
        "Севастополь": "Севастополь",
        
        // Области
        "Амурская область": "Амурская область",
        "Архангельская область": "Архангельская область",
        "Астраханская область": "Астраханская область",
        "Белгородская область": "Белгородская область",
        "Брянская область": "Брянская область",
        "Владимирская область": "Владимирская область",
        "Волгоградская область": "Волгоградская область",
        "Вологодская область": "Вологодская область",
        "Воронежская область": "Воронежская область",
        "Ивановская область": "Ивановская область",
        "Иркутская область": "Иркутская область",
        "Калининградская область": "Калининградская область",
        "Калужская область": "Калужская область",
        "Кемеровская область": "Кемеровская область",
        "Кировская область": "Кировская область",
        "Костромская область": "Костромская область",
        "Курганская область": "Курганская область",
        "Курская область": "Курская область",
        "Ленинградская область": "Ленинградская область",
        "Липецкая область": "Липецкая область",
        "Магаданская область": "Магаданская область",
        "Московская область": "Московская область",
        "Мурманская область": "Мурманская область",
        "Нижегородская область": "Нижегородская область",
        "Новгородская область": "Новгородская область",
        "Новосибирская область": "Новосибирская область",
        "Омская область": "Омская область",
        "Оренбургская область": "Оренбургская область",
        "Орловская область": "Орловская область",
        "Пензенская область": "Пензенская область",
        "Псковская область": "Псковская область",
        "Ростовская область": "Ростовская область",
        "Рязанская область": "Рязанская область",
        "Самарская область": "Самарская область",
        "Саратовская область": "Саратовская область",
        "Сахалинская область": "Сахалинская область",
        "Свердловская область": "Свердловская область",
        "Смоленская область": "Смоленская область",
        "Тамбовская область": "Тамбовская область",
        "Тверская область": "Тверская область",
        "Томская область": "Томская область",
        "Тульская область": "Тульская область",
        "Тюменская область": "Тюменская область",
        "Ульяновская область": "Ульяновская область",
        "Челябинская область": "Челябинская область",
        "Ярославская область": "Ярославская область"
    ] }

    
    init(region: String, city: String, country: String, longitude: Double, latitude: Double) {
        self.region = GeoInfo.regionMapping[region] ?? region
        self.city = city
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
}

public protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double, totalAccuracy: Double)
    func didUpdateLocation(location: GeoInfo, totalAccuracy: Double)
    func didFailWithError(error: Error)
    func didChangeAuthorization(status: CLAuthorizationStatus)
    func didChangeAuthorization(locations: [CLLocation])
}

public extension LocationManagerDelegate {
    func didChangeAuthorization(locations: [CLLocation]) {}
}

public enum LocationError: Error {
    case geoInfo
}


public protocol LocationManager {
    var delegate: LocationManagerDelegate? { get set }
    
    func start(_ needStatus: LocationManagerAuthorizationStatus)
    func stop()
    func getGeoInfo(from location: CLLocationCoordinate2D, completion: @escaping (GeoInfo?) -> Void)
    func getGeoInfo(from location: CLLocationCoordinate2D) -> AnyPublisher<GeoInfo, LocationError>
    func findClosestCoordinate(to targetCoordinate: CLLocationCoordinate2D, from coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D?
}

public enum LocationManagerAuthorizationStatus {
    case authorizedAlways, authorizedWhenInUse
}

public final class LocationManagerImpl: NSObject, CLLocationManagerDelegate, LocationManager {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    weak public var delegate: LocationManagerDelegate?

   public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func start(_ needStatus: LocationManagerAuthorizationStatus = .authorizedAlways) {
        requestLocationAccess(status: needStatus)
        self.locationManager.startUpdatingLocation()
    }
    
    func haversineDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let radius: CLLocationDistance = 6371 // Радиус Земли в километрах
        
        let lat1 = coordinate1.latitude * .pi / 180
        let lon1 = coordinate1.longitude * .pi / 180
        let lat2 = coordinate2.latitude * .pi / 180
        let lon2 = coordinate2.longitude * .pi / 180
        
        let dlat = lat2 - lat1
        let dlon = lon2 - lon1
        
        let a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return radius * c // Расстояние в километрах
    }

    public func findClosestCoordinate(to targetCoordinate: CLLocationCoordinate2D, from coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        var closestCoordinate: CLLocationCoordinate2D?
        var shortestDistance: CLLocationDistance = .greatestFiniteMagnitude
        
        for coordinate in coordinates {
            let distance = haversineDistance(from: targetCoordinate, to: coordinate)
            if distance < shortestDistance {
                shortestDistance = distance
                closestCoordinate = coordinate
            }
        }
        
        return closestCoordinate
    }
    
    public func getGeoInfo(from location: CLLocationCoordinate2D, completion: @escaping (GeoInfo?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(.init(latitude: location.latitude, longitude: location.longitude)) { placemarks, error in
            if error != nil {
                completion(nil)
                return
            }
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
                        
            if let region = placemark.administrativeArea, let city = placemark.locality, let country = placemark.country {
                completion(.init(region: region,
                                 city: city,
                                 country: country,
                                 longitude: location.longitude,
                                 latitude: location.latitude))
            } else {
                completion(nil)
            }
        }
    }

    func requestLocationAccess(status: LocationManagerAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func checkAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        
        delegate?.didChangeAuthorization(status: status)
    }
    
    func combinedAccuracy(horizontal: CLLocationAccuracy, vertical: CLLocationAccuracy) -> CLLocationAccuracy {
        // Проверяем, являются ли значения допустимыми
        guard horizontal >= 0, vertical >= 0 else {
            return -1 // или другое значение, чтобы указать на ошибку
        }
        
        // Вычисляем общую точность с использованием теоремы Пифагора
        let combined = sqrt(horizontal * horizontal + vertical * vertical)
        return combined
    }
    
    public func stop() {
        locationManager.stopUpdatingLocation()
    }

    // CLLocationManagerDelegate методы
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.didUpdateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, totalAccuracy: combinedAccuracy(horizontal: location.horizontalAccuracy, vertical: location.verticalAccuracy))
        handleLocation(location: location, totalAccuracy: combinedAccuracy(horizontal: location.horizontalAccuracy, vertical: location.verticalAccuracy))
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status: status)
    }
    
    public func getGeoInfo(from location: CLLocationCoordinate2D) -> AnyPublisher<GeoInfo, LocationError> {
        let geoceder = CLGeocoder()
        return Future { result in
            geoceder.reverseGeocodeLocation(.init(latitude: location.latitude, longitude: location.longitude)) { placepark, error in
                if error != nil {
                    result(.failure(LocationError.geoInfo))
                    return
                }
                
                guard let placemark = placepark?.first else {
                    result(.failure(LocationError.geoInfo))
                    return
                }
                
                if let region = placemark.administrativeArea, let city = placemark.locality, let country = placemark.country {
                    result(.success(GeoInfo(region: region,
                                            city: city,
                                            country: country,
                                            longitude: location.longitude,
                                            latitude: location.latitude)))
                } else {
                    result(.failure(.geoInfo))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func handleLocation(location: CLLocation, totalAccuracy: Double) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self else { return }
            if let error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            guard let placemarks, let firstPlacemark = placemarks.first else { return }
            
            if let region = firstPlacemark.administrativeArea, let city = firstPlacemark.locality, let country = firstPlacemark.country {
                self.delegate?.didUpdateLocation(location: .init(region: region,
                                                                 city: city,
                                                                 country: country,
                                                                 longitude: location.coordinate.longitude,
                                                                 latitude: location.coordinate.latitude), totalAccuracy: totalAccuracy)

            }
        }
    }
}
