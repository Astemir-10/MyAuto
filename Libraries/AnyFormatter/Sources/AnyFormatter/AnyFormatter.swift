//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import Foundation

class AnyFormatter {}

public enum MeasurementUnit {
    case currency, fuelPrice, mileage, distance, travelTime, time, horsepower, speed, liters, temperature, rpm
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
        case .rpm:
            return "\(Int(self)) об/мин"
        }
    }
}

public enum SmartDateFormatter {
    private static var calendar: Calendar {
        var calndar = Calendar.current
        calndar.locale = .init(identifier: "ru_RU")
        return calndar
    }
    private static let relativeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private static let currentYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("d MMMM")
        return formatter
    }()
    
    private static let otherYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("d MMMM, yyyy")
        return formatter
    }()
    
    static public func string(from date: Date) -> String {
        let now = Date()
        
        // Проверяем, сегодня ли дата
        if SmartDateFormatter.calendar.isDate(date, inSameDayAs: now) {
            return "Сегодня"
        }
        
        // Проверяем, вчерашняя ли дата
        if let yesterday = SmartDateFormatter.calendar.date(byAdding: .day, value: -1, to: now),
           SmartDateFormatter.calendar.isDate(date, inSameDayAs: yesterday) {
            return "Вчера"
        }
        
        // Проверяем, текущий ли год
        if SmartDateFormatter.calendar.component(.year, from: date) == SmartDateFormatter.calendar.component(.year, from: now) {
            return SmartDateFormatter.currentYearFormatter.string(from: date)
        } else {
            return SmartDateFormatter.otherYearFormatter.string(from: date)
        }
    }
}
