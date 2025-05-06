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
import AnyFormatter

protocol CarScannerViewInput: AnyObject {
    func setLiveData(_ data: [LiveData])
    func setCommand(command: String)
    func setConnectionState(model: OBDModel)
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

enum LiveData {
    case speed(String)
    case rpm(String)
    case engineLoad(String)
    case fuel(String)
    case coplantTemperature(String)
    case powerReserve(String)
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
        obdSessionManager.connectionStatePublisher.receive(on: RunLoop.main).sink(receiveValue: { [weak self] model in
            self?.view?.setConnectionState(model: model)
            if model.connectionState == .ready {
                self?.configureOBD {
//                    self?.setLiveSession()
                }
            }
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
    
    private func configureOBD(completion: @escaping () -> ()) {
        Task { [weak self] in
            do {
                let resultsReset = try await self?.obdSessionManager.executeATCommand(ResetCommand())
                print("RESET", resultsReset)
            } catch {
                print(error.localizedDescription)
            }
            
            do {
                let resultsReset = try await self?.obdSessionManager.executeATCommand(CustomATCommand(command: "AT D"))
                print("AT D", resultsReset)
            } catch {
                print(error.localizedDescription)
            }
//            
//            do {
//                let resultsReset = try await self?.obdSessionManager.executeATCommand(CustomATCommand(command: "AT DP"))
//                print("AT DP", resultsReset)
//            } catch {
//                print(error.localizedDescription)
//            }
//            
//            do {
//                let resultsReset = try await self?.obdSessionManager.executeATCommand(CustomATCommand(command: "AT CRA ?"))
//                print("AT CRA", resultsReset)
//            } catch {
//                print(error.localizedDescription)
//            }
            
            let resultsEcho = try? await self?.obdSessionManager.executeATCommand(EchoOffCommand())
            let resultsHe = try? await self?.obdSessionManager.executeATCommand(HeadersOnCommand())

            
            do {
                let extendedPIDs: [String] = [
                    "01 21",
                    "01 22",
                    "2100", "2101", "2102", "2103", "2104", "2105", "2106", "2107", "2108", "2109",
                    "2110", "2111", "2112", "2113", "2114", "2115", "2116", "2117", "2118", "2119",
                    
                    "220001", "220002", "220003", "220004", "220005", "220006", "220007", "220008", "220009",
                    "22000A", "22000B", "22000C", "22000D", "22000E", "22000F",
                    "220010", "220011", "220012", "220013", "220014", "220015",
                    
                    "220020", "220021", "220022", "220023", "220024", "220025",
                    "220030", "220031", "220032", "220033", "220034",
                    
                    "22B001", "22F40D", "222020", "22A003", "22A001",
                    "220D01", "22FF01", "22F121", "22F17C",
                    
                    "220100", "220101", "220102", "220103",
                    
                    "22FE12", "22FE13", "22FE15", // иногда эти возвращают пробег
                ]
                for i in extendedPIDs {
                    let resultsProto1 = try await self?.obdSessionManager.executeATCommand(CustomATCommand(command: i))
                    print(i, resultsProto1!.rawResponse)

                }
            } catch {
                print(error)
            }
            
            
//            do {
//                let resultsHe = try await self?.obdSessionManager.executeATCommand(CustomATCommand(command: "AT AL"))
//                print(resultsHe)
//            } catch {
//                print(error.localizedDescription)
//            }
            
//            do {
//                let resultsHe = try await self?.obdSessionManager.executeATCommand(CustomATCommand(command: "AT ST 64"))
//                print(resultsHe)
//            } catch {
//                print(error.localizedDescription)
//            }
            
//            do {
//                let resultsHe = try await self?.obdSessionManager.executeATCommand(CustomATCommand(command: "AT CRA 1AA"))
//                print("AT CRA", resultsHe)
//            } catch {
//                print(error.localizedDescription)
//            }
            
            
//            do {
//                let resultsHe = try await self?.obdSessionManager.executeATCommand(ATMACommand())
//                print(resultsHe)
//            } catch {
//                print(error.localizedDescription)
//            }

            
            completion()
        }
    }
    
    func configure() {
        
    }
    
    func openConsole() {
        router.openConsole(queueCommands: commands)
    }
    
    func setLiveSession() {
        obdSessionManager.startLiveSession(commands: [CoolantTempCommand(), EngineLoadCommand(), FuelLevelCommand(), VehicleSpeedCommand(), RPMCommand()])
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                var liveData = [LiveData]()
                switch result {
                case .rpm(let rpm):
                    liveData.append(.rpm(Double(rpm).format(.rpm)))
                case .speed(let speed):
                    liveData.append(.speed(Double(speed).format(.speed)))
                case .coolantTemperature(let temp):
                    liveData.append(.coplantTemperature(Double(temp).format(.temperature)))
                case .fuelLevel(let level):
                    liveData.append(.fuel("\(level) %"))
                case .engineLoad(let load):
                    liveData.append(.engineLoad("\(load) %"))
                case .clearDTCSuccess:
                    break
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
                self?.view?.setLiveData(liveData)
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

extension CarScannerPresenter {

    // Функция для преобразования строки в массив байтов
    func stringToBytes(_ hexString: String) -> [UInt8]? {
        let hexStringWithoutSpaces = hexString.replacingOccurrences(of: " ", with: "")
        var bytes = [UInt8]()
        
        // Парсим строку по два символа за раз
        var index = hexStringWithoutSpaces.startIndex
        while index < hexStringWithoutSpaces.endIndex {
            let byteString = hexStringWithoutSpaces[index..<hexStringWithoutSpaces.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                bytes.append(byte)
            } else {
                return nil
            }
            index = hexStringWithoutSpaces.index(index, offsetBy: 2)
        }
        return bytes
    }

    // Функция для извлечения значений из массива байтов (например, пробег)
    func extractPossibleOdometerValues(from bytes: [UInt8]) -> [(offset: Int, length: Int, value: UInt32)] {
        var values = [(offset: Int, length: Int, value: UInt32)]()
        
        // Пример: используем байты для извлечения значений, например, пробег
        // Предположим, что пробег начинается с 3-го байта (индекс 2)
        // 1-й байт: 7E8 - идентификатор, 2-й байт - размер данных, остальное: данные
        if bytes.count >= 8 {
            // Пример для извлечения двух байтов, которые могут быть пробегом
            let byte1 = bytes[2]
            let byte2 = bytes[3]
            
            // Комбинируем байты в одно целое число (например, пробег)
            let odometerValue = UInt32(byte1) << 8 | UInt32(byte2)
            
            // Добавляем в массив значений
            values.append((offset: 2, length: 2, value: odometerValue))
        }
        
        return values
    }

    // Функция, которая будет получать строку, обрабатывать её и выводить значения
    func fetchAndParseOdometerData() async {
        do {
            // Получаем результат команды, например, "7E8 10 1C 62 00 03 82 A6 A4"
            let resultsCommand = try await obdSessionManager.executeATCommand(CustomATCommand(command: "220001"))
            
            // Преобразуем строку в массив байтов
            if let bytes = stringToBytes(resultsCommand.rawResponse) {
                // Извлекаем возможные значения (например, пробег)
                let values = extractPossibleOdometerValues(from: bytes)
                
                // Печатаем извлеченные значения
                for (offset, length, value) in values {
                    print("Offset \(offset), Length \(length): \(value)")
                }
            } else {
                print("Не удалось преобразовать строку в байты.")
            }
            
        } catch {
            print("Error executing OBD command: \(error)")
        }
    }
}
