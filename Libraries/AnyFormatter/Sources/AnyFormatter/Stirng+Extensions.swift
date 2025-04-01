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
    
    static var dateNameFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM, EEEE"
        return dateFormatter
    }
    
    static var simpleFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }
    
    // ISO8601
    static var iso8601: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return dateFormatter
    }
    
    static var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
}

public extension Date {
    func toString(dateForamtter: DateFormatter) -> String {
        dateForamtter.string(from: self)
    }
  
    
    static func weatherApi(dateStr: String) -> Date? {
        DateFormatter.weatherApiDateFormatter.date(from: dateStr)
    }
    
    var dateToString: String {
        DateFormatter.dateNameFormatter.string(from: self)
    }
}


public extension String {
    func toDate(dateForamtter: DateFormatter) -> Date? {
        dateForamtter.date(from: self)
    }
}





