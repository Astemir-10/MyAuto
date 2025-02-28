//
//  File.swift
//  AppMap
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit
import DesignKit
import MapKit

public final class PetrolAnnotation: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    
    
    public init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

final class AppMapViewController: CommonViewController {
    private lazy var mapView = MKMapView().forAutoLayout()
    private lazy var userLocationButton: Button = {
        let button = Button()
        button.setImage(.init(systemName: "location") ?? UIImage())
        button.configure { conf in
            conf.cornerStyle = .rounded
        }
        button.addTarget(self, action: #selector(userLocationTapped), for: .touchUpInside)
        return button
    }()
    
    var annotations: [PetrolAnnotation] = []
    var currentAnnotation: PetrolAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)])
        mapView.delegate = self
        setLocations(annotations: annotations)
        if let currentAnnotation = currentAnnotation {
            setLocation(annotation: currentAnnotation)
        }
        mapView.showsUserLocation = true
        userLocationButton.setSize(width: 56, height: 56)
        view.addSubview(userLocationButton)
        userLocationButton.addConstraintToSuperView([.bottom(-20), .trailing(-20)], withSafeArea: true)
    }
    
    @objc
    private func userLocationTapped() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
}

extension AppMapViewController: MKMapViewDelegate {
    func setLocations(annotations: [PetrolAnnotation]) {
        annotations.forEach({
            mapView.addAnnotation($0)
        })
    }
    
    func setLocation(annotation: PetrolAnnotation) {
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let regionRadius: CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let reuseId = "customAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if annotationView == nil {
                // Создаем новый MKAnnotationView
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView?.canShowCallout = true
                
                // Устанавливаем кастомное изображение
                annotationView?.image = UIImage(named: "customImage")  // Укажите имя вашего изображения здесь
                
                // Настройки для стрелки (опционально)
                annotationView?.centerOffset = CGPoint(x: 0, y: -15)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
}
