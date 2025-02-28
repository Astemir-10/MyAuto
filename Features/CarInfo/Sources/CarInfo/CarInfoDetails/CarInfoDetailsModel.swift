//
//  CarInfoDetailsModel.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import Foundation
import AppServices
import CombineCoreData

public class CarInfoDetailsModel {
    public var carBrand: String
    public var carModel: String
    public var year: String
    public var color: String
    public var power: Int
    public var volume: Double
    public var mileage: Int
    public var number: String?
    
    init(carData: CarInfoModel.CarData, number: String?) {
        var components = carData.model.components(separatedBy: " ")
        self.carBrand = components.removeFirst()
        self.carModel = components.reduce("", { partialResult, current in
            return partialResult + " " + current
        })
        self.year = String(carData.year)
        self.volume = Double(carData.volume)
        self.color = carData.color
        self.mileage = 0
        self.power = carData.power
        self.number = number
    }
    
    init() {
        carBrand = ""
        carModel = ""
        year = ""
        color = ""
        power = 0
        volume = 0
        mileage = 0
        self.number = nil
    }
    
    public init(carInfo: CarInfo) {
        carBrand = carInfo.mark ?? ""
        carModel = carInfo.model ?? ""
        if let year = carInfo.year?.intValue {
            self.year = String(year)
        } else {
            year = ""
        }
        
        color = carInfo.color ?? ""
        power = carInfo.power?.intValue ?? 0
        volume = carInfo.volumeEngine?.doubleValue ?? 0
        mileage = carInfo.mileage?.intValue ?? 0
        self.number = carInfo.number
    }
    
    public func convert(_ object: CarInfo) {
        object.mark = carBrand
        object.volumeEngine = NSNumber(value: volume)
        object.color = color
        object.model = carModel
        object.mileage = NSNumber(value: mileage)
        object.power = NSNumber(value: power)
        if let year = Int(year) {
            object.year = NSNumber(value: year)
        } else {
            object.year = nil
        }
        object.number = number

    }
}
