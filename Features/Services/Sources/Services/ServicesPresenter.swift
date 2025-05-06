//
//  File.swift
//  Profile
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import CarInfo
import CombineCoreData
import Architecture
import Combine
import Extensions

protocol ServicesViewInput: AnyObject {
}

protocol ServicesViewOutput {
    func viewDidLoad()
    func didTapService(service: Service)
}

final class ServicesPresenter: ServicesViewOutput {
    
    weak var view: ServicesViewInput?
    
    private let router: ServicesRouterInput
    private var cancellables = Set<AnyCancellable>()
    
    init(view: ServicesViewInput, router: ServicesRouterInput) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
}

extension ServicesPresenter {
    func didTapService(service: Service) {
        switch service {
        case .obdDiagnostic:
            router.openOBDScaenner()
        case .carCheck:
            router.openCarCheck()
        case .driverCheck:
            router.openDriverCheck()
        case .finesCheck:
            router.openFinesCheck()
        case .carСomparator:
            break
        case .costEstimation:
            break
        case .towTruck:
            break
        }
    }
}
