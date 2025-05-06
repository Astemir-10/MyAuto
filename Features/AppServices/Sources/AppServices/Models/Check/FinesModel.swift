//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import Foundation

public struct FineResponse: Decodable {
    public let durationReg: Int
    public let request: String
    public let code: Int
    public let data: [FineData]
}

public struct FineData: Decodable {
    public let discount: String
    public let enableDiscount: Bool
    public let dateDecis: String
    public let koAPcode: String
    public let dateDiscount: String
    public let vehicleModel: String
    public let breachYear: Int
    public let koAPtext: String
    public let numPost: String
    public let kbk: String
    public let summa: Int
    public let division: Int
    public let enablePics: Bool
    public let id: String
    public let supplierBillID: String
    public let datePost: String
    public let dateSSP: String?

    enum CodingKeys: String, CodingKey {
        case discount = "Discount"
        case enableDiscount
        case dateDecis = "DateDecis"
        case koAPcode = "KoAPcode"
        case dateDiscount = "DateDiscount"
        case vehicleModel = "VehicleModel"
        case breachYear
        case koAPtext = "KoAPtext"
        case numPost = "NumPost"
        case kbk
        case summa = "Summa"
        case division = "Division"
        case enablePics
        case id
        case supplierBillID = "SupplierBillID"
        case datePost = "DatePost"
        case dateSSP = "DateSSP"
    }
}
