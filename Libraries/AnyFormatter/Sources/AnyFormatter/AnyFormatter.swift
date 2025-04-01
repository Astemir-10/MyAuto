//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import Foundation

class AnyFormatter {}

public enum MeasurementUnit {
    case currency, fuelPrice, mileage, distance, travelTime, time, horsepower, speed, liters, temperature
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
            let distanceKilometr = self / 1000
            return self < 1.0 ? "\(Int(distanceKilometr)) м" : "\(NumberFormatter.distanceFormatter.string(from: NSNumber(value: distanceKilometr)) ?? "-") км"
        case .travelTime:
            let minutes = Int(self)
            if minutes < 60 {
                return "\(minutes) мин"
            } else {
                let hours = minutes / 60
                let mins = minutes % 60
                return mins == 0 ? "\(hours) ч" : "\(hours) ч \(mins) мин"
            }
        case .time:
            let totalSeconds = Int(self)
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60
            
            if hours > 0 {
                return minutes == 0 ? "\(hours) ч" : "\(hours) ч \(minutes) мин"
            } else if minutes > 0 {
                return seconds == 0 ? "\(minutes) мин" : "\(minutes) мин \(seconds) сек"
            } else {
                return "\(seconds) сек"
            }
        case .horsepower:
            return "\(Int(self)) л.с."
        case .speed:
            return "\(Int(self)) км/ч"
        case .liters:
            return "\(Int(self)) л"
        case .temperature:
            if self < 0 {
                return "- \(Int(self)) °C"
            } else {
                return "\(Int(self)) °C"
            }
        }
    }
}
