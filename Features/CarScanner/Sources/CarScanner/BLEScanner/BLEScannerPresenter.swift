//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import CarScannerCore
import Combine
import UserDefaultsExtensions

protocol BLEScannerViewOutput {
    func setup()
    func didSelect(index: Int)
}

protocol BLEScannerViewInput: AnyObject {
    func setItems(items: [BLEScannerModel])
    func dismissVC()
    
}

final class BLEScannerPresenter: BLEScannerViewOutput {
    private weak var view: BLEScannerViewInput?
    private let connector: OBDConnector
    private weak var moduleOutput: BLEScannerModuleOutput?
    private var cancellables = Set<AnyCancellable>()
    private var items: [OBDConnectionModel] = []
    
    init(moduleOutput: BLEScannerModuleOutput, connector: OBDConnector, view: BLEScannerViewInput) {
        self.view = view
        self.connector = connector
        self.moduleOutput = moduleOutput
    }
    
    func setup() {
        connector.dicoveredConnections
            .receive(on: RunLoop.main)
            .sink { [weak self] models in
                self?.items = models
            self?.view?.setItems(items: models.map({ .init(name: $0.name, id: $0.id) }))
        }
        .store(in: &cancellables)
        connector.startScan()
    }
    
    func didSelect(index: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let transport = try await self.connector.connect(id: items[index].id)
                UserDefaults.appDefaults.set(name: .obdScannerId, string: items[index].id)
                self.moduleOutput?.didConnectDevice(transport: transport)
                self.view?.dismissVC()
            } catch {
                print(error)
                
            }
            
        }
        
    }
}
