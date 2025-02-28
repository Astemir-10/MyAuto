//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 03.11.2024.
//

import Foundation


public struct PetrolStationsResponse: Decodable {
    public let stations: [PetrolItemModel]
}
/*
public struct PetrolItemModel: Decodable {
    public enum PetrolType: Int, Decodable {
        case rosneft = 127
        case gazpromneft = 118
        case lukoil = 119
        
        public var name: String {
            switch self {
            case .rosneft:
                "Роснефть"
            case .gazpromneft:
                "Газпромнефть"
            case .lukoil:
                "Лукойл"
            }
        }
    }
    public let name: String
    public let petrol: PetrolType?
    public let ai80: Double?
    public let ai92: Double?
    public let ai92plus: Double?
    public let ai95: Double?
    public let ai95plus: Double?
    public let ai98: Double?
    public let ai98plus: Double?
    public let ai100: Double?
    public let dt: Double?
    public let dtplus: Double?
    public let gas: Double?
    public let propan: Double?
 public let regionName: String?
 public let cityName: String?

    public let longitude: Double?
    public let latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case brandId
        case ai80
        case ai92
        case ai92plus
        case ai95
        case ai95plus
        case ai98
        case ai98plus
        case ai100
        case dt
        case dtplus
        case gas
        case propan
        case longitude = "x"
        case latitude = "y"
        case regionName = "region_name"
        case cityName = "city_name"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.petrol = PetrolType(rawValue: Int(try container.decode(String.self, forKey: .brandId)) ?? 400)
        self.ai80 = Double(try container.decodeIfPresent(String.self, forKey: .ai80) ?? "")
        self.ai92 = Double(try container.decodeIfPresent(String.self, forKey: .ai92) ?? "")
        self.ai92plus = Double(try container.decodeIfPresent(String.self, forKey: .ai92plus) ?? "")
        self.ai95 = Double(try container.decodeIfPresent(String.self, forKey: .ai95) ?? "")
        self.ai95plus = Double(try container.decodeIfPresent(String.self, forKey: .ai95plus) ?? "")
        self.ai98 = Double(try container.decodeIfPresent(String.self, forKey: .ai98) ?? "")
        self.ai98plus = Double(try container.decodeIfPresent(String.self, forKey: .ai98plus) ?? "")
        self.ai100 = Double(try container.decodeIfPresent(String.self, forKey: .ai100) ?? "")
        self.dt = Double(try container.decodeIfPresent(String.self, forKey: .dt) ?? "")
        self.dtplus = Double(try container.decodeIfPresent(String.self, forKey: .dtplus) ?? "")
        self.gas = Double(try container.decodeIfPresent(String.self, forKey: .gas) ?? "")
        self.propan = Double(try container.decodeIfPresent(String.self, forKey: .propan) ?? "")
        self.longitude = Double(try container.decodeIfPresent(String.self, forKey: .longitude) ?? "")
        self.latitude = Double(try container.decodeIfPresent(String.self, forKey: .latitude) ?? "")
        self.regionName = try container.decodeIfPresent(String.self, forKey: .regionName)
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
    }
}
*/
public struct PetrolItemModel: Decodable {
    public enum PetrolType: Int, Decodable {
        case rosneft = 127
        case gazpromneft = 118
        case lukoil = 119
        
        public var name: String {
            switch self {
            case .rosneft:
                "Роснефть"
            case .gazpromneft:
                "Газпромнефть"
            case .lukoil:
                "Лукойл"
            }
        }
    }
    public var longitude: Double?
    public var latitude: Double?
    public var poiid: String
    public var raionType: String
    public var cityType: String
    public var name: String
    public var address: String
    public var rubricId: String
    public var regionId: String
    public var raionId: String
    public var cityId: String
    public var regionName: String
    public var raionName: String
    public var cityName: String
    public var trassaName: String?
    public var petrol: PetrolType?
    public var lastUpdate: String
    public var ai80: Double?
    public var ai92: Double?
    public var ai92plus: Double?
    public var ai95: Double?
    public var ai95plus: Double?
    public var ai98: Double?
    public var ai98plus: Double?
    public var ai100: Double?
    public var dt: Double?
    public var dtplus: Double?
    public var gas: Double?
    public var propan: Double?
    public var uslugi: [Uslugi]?
    public var pricesUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case longitude = "x"
        case latitude = "y"
        case poiid
        case raionType = "raion_type"
        case cityType = "city_type"
        case name
        case address
        case rubricId = "rubric_id"
        case regionId = "region_id"
        case raionId = "raion_id"
        case cityId = "city_id"
        case regionName = "region_name"
        case raionName = "raion_name"
        case cityName = "city_name"
        case trassaName = "trassa_name"
        case brandId = "brand_id"
        case lastUpdate = "LastUpdate"
        case ai80
        case ai92
        case ai92plus
        case ai95
        case ai95plus
        case ai98
        case ai98plus
        case ai100
        case dt
        case dtplus
        case gas
        case propan
        case uslugi
        case pricesUpdated = "prices_updated"
    }
    
    public struct Uslugi: Decodable {
        public let name: String
        public let id: String
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.longitude = Double(try container.decodeIfPresent(String.self, forKey: .longitude) ?? "")
        self.latitude = Double(try container.decodeIfPresent(String.self, forKey: .latitude) ?? "")
        self.poiid = try container.decode(String.self, forKey: .poiid)
        self.raionType = try container.decode(String.self, forKey: .raionType)
        self.cityType = try container.decode(String.self, forKey: .cityType)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.rubricId = try container.decode(String.self, forKey: .rubricId)
        self.regionId = try container.decode(String.self, forKey: .regionId)
        self.raionId = try container.decode(String.self, forKey: .raionId)
        self.cityId = try container.decode(String.self, forKey: .cityId)
        self.regionName = try container.decode(String.self, forKey: .regionName)
        self.raionName = try container.decode(String.self, forKey: .raionName)
        self.cityName = try container.decode(String.self, forKey: .cityName)
        self.trassaName = try container.decodeIfPresent(String.self, forKey: .trassaName)
        self.petrol = PetrolType(rawValue: Int(try container.decode(String.self, forKey: .brandId)) ?? 400)
        self.lastUpdate = try container.decode(String.self, forKey: .lastUpdate)
        self.ai80 = Double(try container.decodeIfPresent(String.self, forKey: .ai80) ?? "")
        self.ai92 = Double(try container.decodeIfPresent(String.self, forKey: .ai92) ?? "")
        self.ai92plus = Double(try container.decodeIfPresent(String.self, forKey: .ai92plus) ?? "")
        self.ai95 = Double(try container.decodeIfPresent(String.self, forKey: .ai95) ?? "")
        self.ai95plus = Double(try container.decodeIfPresent(String.self, forKey: .ai95plus) ?? "")
        self.ai98 = Double(try container.decodeIfPresent(String.self, forKey: .ai98) ?? "")
        self.ai98plus = Double(try container.decodeIfPresent(String.self, forKey: .ai98plus) ?? "")
        self.ai100 = Double(try container.decodeIfPresent(String.self, forKey: .ai100) ?? "")
        self.dt = Double(try container.decodeIfPresent(String.self, forKey: .dt) ?? "")
        self.dtplus = Double(try container.decodeIfPresent(String.self, forKey: .dtplus) ?? "")
        self.gas = Double(try container.decodeIfPresent(String.self, forKey: .gas) ?? "")
        self.propan = Double(try container.decodeIfPresent(String.self, forKey: .propan) ?? "")
        self.uslugi = try container.decodeIfPresent([Uslugi].self, forKey: .uslugi)
        self.pricesUpdated = try container.decode(String.self, forKey: .pricesUpdated)

    }
    
}
