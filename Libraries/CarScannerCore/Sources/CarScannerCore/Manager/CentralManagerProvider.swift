//
//  File.swift
//  CarScannerCore
//
//  Created by Astemir Shibzuhov on 16.04.2025.
//

import Foundation
import CoreBluetooth


final class CentralManagerProvider {
    static let shared = CentralManagerProvider()
    let centralManager: CBCentralManager

    private init() {
        centralManager = CBCentralManager(delegate: nil, queue: .main)
    }

//    func addDelegate(_ delegate: CBCentralManagerDelegate) {
//        queue.async(flags: .barrier) {
//            self.eventProxy.addDelegate(delegate)
//        }
//    }
//    
//    func removeDelegate(_ delegate: CBCentralManagerDelegate) {
//        queue.async(flags: .barrier) {
//            self.eventProxy.removeDelegate(delegate)
//        }
//    }
}

/*
final class BluetoothEventProxy: NSObject, CBCentralManagerDelegate {
    private var handlers = NSHashTable<AnyObject>.weakObjects()

    func addDelegate(_ handler: CBCentralManagerDelegate) {
        handlers.add(handler)
    }

    func removeDelegate(_ handler: CBCentralManagerDelegate) {
        handlers.remove(handler)
    }

    override func responds(to aSelector: Selector!) -> Bool {
        // нужно, чтобы CBCentralManager корректно форвардил вызовы только если есть поддержка
        return super.responds(to: aSelector) ||
            handlers.allObjects.contains { ($0 as? NSObject)?.responds(to: aSelector) == true }
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        // не используется, но можно настроить fallback
        return nil
    }

    // MARK: - CBCentralManagerDelegate forwarding

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        handlers.allObjects.forEach {
            ($0 as? CBCentralManagerDelegate)?.centralManagerDidUpdateState(central)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        handlers.allObjects.forEach {
            ($0 as? CBCentralManagerDelegate)?.centralManager?(central,
                didDiscover: peripheral,
                advertisementData: advertisementData,
                rssi: RSSI)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        handlers.allObjects.forEach {
            ($0 as? CBCentralManagerDelegate)?.centralManager?(central, didConnect: peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        handlers.allObjects.forEach {
            ($0 as? CBCentralManagerDelegate)?.centralManager?(central,
                                                               didFailToConnect: peripheral,
                                                               error: error)
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        handlers.allObjects.forEach {
            ($0 as? CBCentralManagerDelegate)?.centralManager?(central,
                                                               didDisconnectPeripheral: peripheral,
                                                               error: error)
        }
    }
}
*/
