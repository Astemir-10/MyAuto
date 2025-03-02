//
//  File.swift
//  AnyFormatter
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import Foundation

public extension String {
    var carNumerFormatted: String {
        let pattern = "(\\D)(\\d+)(\\D{2})(\\d{2})"

        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        let formattedPlate = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count),
            withTemplate: "$1 $2 $3 $4"
        )

        return formattedPlate
    }
}

public extension DateFormatter {
    static var weatherApiDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}

public extension Date {
    static func weatherApi(dateStr: String) -> Date? {
        DateFormatter.weatherApiDateFormatter.date(from: dateStr)
    }
}




