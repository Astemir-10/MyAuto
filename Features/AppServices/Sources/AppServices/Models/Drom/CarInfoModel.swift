//
//  File.swift
//  
//
//  Created by Astemir Shibzuhov on 21.09.2024.
//

import Foundation

public struct CarInfoModel: Decodable {
    public enum State: String {
        case fetched, pending
    }
    
    public struct CarData: Decodable {
        public let model: String
        public let year: Int
        public let color: String
        public let power: Int
        public let volume: Int // объем двигателя в см3
        public let image: String?
    }
    
    public let status: Bool
    public let state: State
    public let carData: CarData?
    
    public enum CodingKeys: CodingKey {
        case status
        case state
        case carData
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.state = .init(rawValue: try container.decode(String.self, forKey: .state)) ?? .pending
        self.carData = try? container.decode(CarData.self, forKey: .carData)
        self.status = try container.decode(Bool.self, forKey: .status)
    }
}
