//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import Foundation

public struct CarRegisterResponse: Decodable {
    public let requestTime: String
    public let requestResult: CarRegister
    public let hostname: String
    public let vin: String
    public let regnum: String
    public let message: String
    public let registerToken: String
    public let status: Int

    enum CodingKeys: String, CodingKey {
        case requestTime
        case requestResult = "RequestResult"
        case hostname
        case vin
        case regnum
        case message
        case registerToken
        case status
    }
}

public struct CarRegister: Decodable {
    public let vehicleChassisNumber: String
    public let vehicleEcoClass: String
    public let chour: String
    public let vehicleTypeName: String
    public let vehicleBrandModel: String
    public let cyear: String
    public let vehicleEnclosedVolume: String
    public let vehicleReleaseYear: String
    public let cminute: String
    public let vehicleVIN: String
    public let vehicleEnginePowerKW: String
    public let cday: String
    public let vehicleEnginePower: String
    public let periods: [CarRegisterOwnershipPeriod]
    public let vehicleBodyColor: String
    public let vehicleBodyNumber: String
    public let cmonth: String
    public let reestrStatus: String

    enum CodingKeys: String, CodingKey {
        case vehicleChassisNumber = "vehicle_chassisnumber"
        case vehicleEcoClass = "vehicle_eco_class"
        case chour
        case vehicleTypeName = "vehicle_type_name"
        case vehicleBrandModel = "vehicle_brandmodel"
        case cyear
        case vehicleEnclosedVolume = "vehicle_enclosedvolume"
        case vehicleReleaseYear = "vehicle_releaseyear"
        case cminute
        case vehicleVIN = "vehicle_vin"
        case vehicleEnginePowerKW = "vehicle_enginepowerkw"
        case cday
        case vehicleEnginePower = "vehicle_enginepower"
        case periods
        case vehicleBodyColor = "vehicle_bodycolor"
        case vehicleBodyNumber = "vehicle_body_number"
        case cmonth
        case reestrStatus = "reestr_status"
    }
}

public struct CarRegisterOwnershipPeriod: Decodable {
    public let ownerType: String
    public let endDate: String
    public let startDate: String
}
