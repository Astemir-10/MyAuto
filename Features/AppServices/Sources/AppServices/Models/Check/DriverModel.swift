//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import Foundation

public struct DriverModel: Decodable {
    public let requestTime: String
    public let hostname: String
    public let code: Int
    public let count: Int
    public let doc: DriverDocumentModel
    public let message: String
//    public let decis: [String] // Тип зависит от содержимого, пока пустой массив
    
    public struct DriverDocumentModel: Decodable {
        public let date: String
        public let bdate: String
        public let num: String
        public let index: String
        public let type: String
        public let srok: String
        public let division: String
        public let stag: String
        public let nameop: String
        public let codeop: String
        public let cat: String
        public let vUch: String
        public let time: Int64
        public let stKart: String
        public let divid: String
        public let status: String
        
        enum CodingKeys: String, CodingKey {
            case date
            case bdate
            case num
            case index
            case type
            case srok
            case division
            case stag
            case nameop
            case codeop
            case cat
            case vUch = "v_uch"  // "v_uch" в JSON, а в модели используем "vUch"
            case time
            case stKart = "st_kart"  // "st_kart" в JSON, а в модели используем "stKart"
            case divid
            case status
        }
    }
}
