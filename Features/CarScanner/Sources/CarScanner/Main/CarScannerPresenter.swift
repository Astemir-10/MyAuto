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
    func setConnectionState(_ state: ConnectionState)
    func setTransportState(_ state: TransportState)
    func setAvailableCommandsResult(_ result: String)
    func setSpeed(speed: String)
    func setRPM(rpm: String)
}

protocol CarScannerViewOutput {
    func setup()
    func didTapConnect()
    func configure()
    func openConsole()
    func setLiveSession()
    func didTapCommands() async
}

final class CarScannerPresenter: CarScannerViewOutput, BLEScannerModuleOutput {

    private weak var view: CarScannerViewInput?
    private let obdSessionManager: OBDSessionManager
    private let router: CarScannerRouterInput
    private var commands: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(view: CarScannerViewInput, router: CarScannerRouterInput) {
        self.view = view
        self.router = router
        obdSessionManager = OBDModuleFactory.makeBluetoothOBDExecutor()
    }
    
    func setup() {
        obdSessionManager.connectionStatePublisher.receive(on: RunLoop.main).sink(receiveValue: { [weak self] connectionState in
            self?.view?.setConnectionState(connectionState)
        })
        .store(in: &cancellables)
        
        obdSessionManager.transportStatePublisher.receive(on: RunLoop.main).sink(receiveValue: { [weak self] transportState in
            self?.view?.setTransportState(transportState)
        })
        .store(in: &cancellables)

        Task { [weak self] in
            do {
                try await self?.obdSessionManager.getConnector()?.reconnect()
                print("SUCCESS RECONNECt")
            } catch {
                print("Error", error.localizedDescription)
            }
        }
    }
    
    func didTapConnect() {
        if let connector = obdSessionManager.getConnector() {
            router.openBLEScanner(connector: connector, moduleOutput: self)
        }
    }
    
    func didConnectDevice(transport: OBDTransport) {
        
    }
    
    private func configureOBD() {
        Task { [weak self] in
            let resultsReset = try? await self?.obdSessionManager.executeATCommand(ResetCommand())
            let resultsEcho = try? await self?.obdSessionManager.executeATCommand(EchoOffCommand())
            let resultsHe = try? await self?.obdSessionManager.executeATCommand(HeadersOnCommand())
            let resultsProto = try? await self?.obdSessionManager.executeATCommand(SetProtocolCommand(protocolNumber: 0))
            print(resultsEcho, "ECHO")

        }
    }
    
    func configure() {
        configureOBD()
    }
    
    func openConsole() {
        router.openConsole(queueCommands: commands)
    }
    
    func setLiveSession() {
//        Task {
//            do {
//                let result = try await obdSessionManager?.executeOBDCommand(RPMCommand())
//                print(result)
//            } catch {
//                print("RPM ERROR")
//                print(error.localizedDescription)
//            }
//        }
        
        obdSessionManager.startLiveSession(commands: [VehicleSpeedCommand(), RPMCommand()])
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                var command = ""
                print(result)
                switch result {
                case .clearDTCSuccess:
                    break
                case .rpm(let rpm):
                    command += "RPM Command\n\(rpm)"
                    self?.view?.setSpeed(speed: String(rpm))
                case .speed(let speed):
                    command += "Speed Command\n\(speed)"
                    self?.view?.setRPM(rpm: String(speed))
                case .troubleCodes(let codes):
                    break
                case .clearCodes:
                    break
                case .runTime(let time):
                    break
                case .temperature(let temp):
                    break
                case .throttlePosition(let trottle):
                    break
                case .custom(_, _):
                    break
                case .vin(_):
                    break
                case .maf(_):
                    break
                case .dtcs(_):
                    break
                }
                self?.commands.append(command)
            })
            .store(in: &cancellables)
    }
    
    func didTapCommands() async {
        var resultText = ""
        var commands = [any OBDCommandItem]()
        
        
        OBDMode.allCases.filter({ $0.isAvailable }).forEach({ commands.append(AvailableCommandsCommand(for: $0)) })
        do {
            let result = try await obdSessionManager.executeOBDCommands(commands)
            result.forEach({
                if case .custom(let command, let result) = try? $0.result.get() {
                    resultText += "\(command): \(result)\n"
                }
            })
        }  catch {
            print(error.localizedDescription)
        }
        view?.setAvailableCommandsResult(resultText)
        
    }
}
