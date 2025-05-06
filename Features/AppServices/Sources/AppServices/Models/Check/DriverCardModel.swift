//
//  File.swift
//  AppServices
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import Foundation

public struct DriverCardModel: Decodable {
    public let requestTime: String
    public let requestResult: DriverCardRequestResult
    public let hostname: String
    public let vin: String
    public let status: Int

    enum CodingKeys: String, CodingKey {
        case requestTime
        case requestResult = "RequestResult"
        case hostname
        case vin
        case status
    }
}

public struct DriverCardRequestResult: Decodable {
    public let diagnosticCards: [DiagnosticCard]
    public let error: String?
    public let status: String
}

public struct DiagnosticCard: Decodable {
    public let dcExpirationDate: String
    public let pointAddress: String
    public let chassis: String
    public let body: String
    public let operatorName: String
    public let pdfBase64: String?
    public let odometerValue: String
    public let dcNumber: String
    public let dcDate: String
    public let previousDcs: [PreviousDc]
    public let success: Bool
    public let vin: String
    public let model: String
    public let brand: String

}

public struct PreviousDc: Decodable {
    public let odometerValue: String
    public let dcExpirationDate: String
    public let dcNumber: String
    public let dcDate: String

}
