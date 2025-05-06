//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import Foundation
import Combine
/*
 DefaultOBDExecutor — это ядро логики модуля, связующее звено между:
 •    выбранным транспортом (BluetoothOBDTransport, WiFiOBDTransport),
 •    командами (OBDCommand),
 •    и клиентским кодом (то, что вызывает диагностику)
 
 Что делает DefaultOBDExecutor:
 
 1. Принимает команду (OBDCommand)
 
 2. Отправляет строку команды через транспорт
 
 3. Получает и парсит ответ
 
 4. Возвращает результат (OBDResult)
 */


enum OBDExecutorError: Error {
    case notConnected, resultType
}

extension ConnectionState: Equatable {
    public static func == (lhs: ConnectionState, rhs: ConnectionState) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected),
             (.connecting, .connecting),
             (.connected, .connected):
            return true
        case (.error, .error):
            return true // или false, если ошибки важно различать
        case (.ready, .ready):
            return true
        default:
            return false
        }
    }
}

