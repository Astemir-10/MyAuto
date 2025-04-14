//
//  File 2.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import CarScannerCore
import Combine
import Extensions

protocol CarScannerViewInput: AnyObject {
    func setCommand(command: String)
    
}

protocol CarScannerViewOutput {
    func setup()
    func didTapConnect()
}

final class CarScannerPresenter: CarScannerViewOutput, BLEScannerModuleOutput {
    private weak var view: CarScannerViewInput?
    private var executor: OBDExecutor?
    private let router: CarScannerRouterInput
    private var cancellables = Set<AnyCancellable>()
    
    init(view: CarScannerViewInput, router: CarScannerRouterInput) {
        self.view = view
        self.router = router
    }
    
    func setup() {
        
    }
    
    func didTapConnect() {
        router.openBLEScanner(moduleOutput: self)
    }
    
    func didConnectDevice(transport: OBDTransport) {
        executor = OBDModuleFactory.makeBluetoothOBDExecutor(transport: transport)
    }
}
