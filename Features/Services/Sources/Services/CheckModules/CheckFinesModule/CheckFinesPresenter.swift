//
//  File.swift
//  Services
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import Foundation
import AppServices
import Combine
import DesignKit

protocol CheckFinesViewInput: AnyObject, LoaderViewInput, ErrorViewInput {
    func buildForMode(mode: CheckFinesMode)
    func setResponse(model: Any)
}

protocol CheckFinesViewOutput {
    func viewDidLoad()
}

public enum CheckFinesMode {
    case driver, fines, car
}

final class CheckFinesPresenter: CheckFinesViewOutput, CheckViewOutput {
    private weak var view: CheckFinesViewInput?
    
    private let mode: CheckFinesMode
    private let checkService: CheckService
    private var cancellable = Set<AnyCancellable>()

    
    init(checkService: CheckService, mode: CheckFinesMode, view: CheckFinesViewInput) {
        self.view = view
        self.mode = mode
        self.checkService = checkService
    }
    
    func viewDidLoad() {
        view?.buildForMode(mode: mode)
    }
    
    func didTapStart(data: [String : String]) {
        view?.showLoader()
        switch mode {
        case .driver:
            let dateFormatter = DateFormatter()
            if let number = data["number"], let dateStr = data["date"], let date = dateFormatter.date(from: dateStr) {
                checkService
                    .requestDriver(number: number, date: date)
                    .sink(receiveError: { [weak self] error in
                        self?.view?.showAlertError(text: error.localizedDescription)
                    }, receiveValue: { [weak self] driverModel in
                        self?.view?.setResponse(model: driverModel)
                        self?.view?.hideLoader()
                    })
                    .store(in: &cancellable)
            }
        case .fines:
            if let sts = data["sts"], let plate = data["plate"] {
                checkService
                    .requestFines(sts: sts, plate: plate)
                    .sink(receiveError: { [weak self] error in
                        self?.view?.showAlertError(text: error.localizedDescription)
                    }, receiveValue: { [weak self] driverModel in
                        self?.view?.setResponse(model: driverModel)
                        self?.view?.hideLoader()
                    })
                    .store(in: &cancellable)
            }
        case .car:
            if let vin = data["vin"] {
                checkService
                    .requestCarInfo(by: vin)
                    .sink(receiveError: { [weak self] error in
                        self?.view?.showAlertError(text: error.localizedDescription)
                    }, receiveValue: { [weak self] driverModel in
                        self?.view?.setResponse(model: driverModel)
                        self?.view?.hideLoader()
                    })
                    .store(in: &cancellable)
            }
        }
    }
}
