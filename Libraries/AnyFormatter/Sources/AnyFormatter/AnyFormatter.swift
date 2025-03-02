//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import Foundation

class AnyFormatter {}

public enum MeasurementUnit {
    case currency, fuelPrice, mileage, distance, travelTime, seconds, horsepower, speed, liters
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₽"
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let fuelPriceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static let distanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    static func formatThousandSeparator(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

public extension Double {
    func format(_ measurement: MeasurementUnit) -> String {
        switch measurement {
        case .currency:
            return NumberFormatter.currencyFormatter.string(from: NSNumber(value: self)) ?? "\(self) ₽"
        case .fuelPrice:
            return "\(NumberFormatter.fuelPriceFormatter.string(from: NSNumber(value: self)) ?? "-") ₽/л"
        case .mileage:
            return "\(NumberFormatter.formatThousandSeparator(Int(self))) км"
        case .distance:
            return self < 1.0 ? "\(Int(self * 1000)) м" : "\(NumberFormatter.distanceFormatter.string(from: NSNumber(value: self)) ?? "-") км"
        case .travelTime:
            let minutes = Int(self)
            if minutes < 60 {
                return "\(minutes) мин"
            } else {
                let hours = minutes / 60
                let mins = minutes % 60
                return mins == 0 ? "\(hours) ч" : "\(hours) ч \(mins) мин"
            }
        case .seconds:
            return "\(Int(self)) сек"
        case .horsepower:
            return "\(Int(self)) л.с."
        case .speed:
            return "\(Int(self)) км/ч"
        case .liters:
            return "\(Int(self)) л"
        }
    }
}
