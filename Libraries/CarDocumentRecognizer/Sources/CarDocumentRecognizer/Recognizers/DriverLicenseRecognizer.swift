//
//  File 3.swift
//  CarDocumentRecognizer
//
//  Created by Astemir Shibzuhov on 12.03.2025.
//

import UIKit
import AnyFormatter
import SwiftyTesseract
import Extensions

//public protocol ConvertibleToDictionary: Codable {
//    func toDictionary() -> [String: Any]
//    init(from dictionary: [String: Any]) throws
//}
//
//public extension ConvertibleToDictionary {
//    
//    // Преобразование структуры в словарь
//    func toDictionary() -> [String: Any] {
//        let encoder = JSONEncoder()
//        
//        // Настроим кастомный форматтер для Date
//        let dateFormatter = DateFormatter.simpleFormatter
//        
//        encoder.dateEncodingStrategy = .formatted(dateFormatter)
//        
//        do {
//            let data = try encoder.encode(self)
//            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
//                return jsonObject as? [String: Any] ?? [:]
//            }
//        } catch {
//            print("Ошибка при кодировании структуры: \(error)")
//        }
//        return [:]
//    }
//    
//    // Инициализация структуры из словаря
//    init(from dictionary: [String: Any]) throws {
//        let decoder = JSONDecoder()
//        
//        // Настроим кастомный форматтер для Date
//        let dateFormatter = DateFormatter.simpleFormatter
//        
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//        
//        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
//            self = try decoder.decode(Self.self, from: data)
//        } else {
//            throw NSError(domain: "Invalid dictionary", code: 1, userInfo: nil)
//        }
//    }
//}


public struct DriverLicenseModel: ConvertibleToDictionary {
    public var name: String?
    public var surname: String?
    public var number: String?
    public var driverDate: Date?
    public var startDate: Date?
    public var expiredDate: Date?
    public var category: String?
}

final class DriverLicenseRecognizer: CarDocumentRecognizer {
    
    func recognize(image: UIImage, completion: @escaping (Result<ConvertibleToDictionary, DocumentsError>) -> Void) {
//        if let imageData = image.pngData() {
//            DispatchQueue.global().async { [weak self] in
//                guard let self else {
//                    return
//                }
//                let tesseract = SwiftyTesseract.Tesseract(languages: [.russian], dataSource: Bundle.module, engineMode: .lstmOnly)
//                
//                
//                let perform = tesseract.performOCR(on: imageData)
//                switch perform {
//                case .success(let success):
//                    var driverModel = DriverLicenseModel()
//
//                    let nameSurname = extractFields(from: success)
//                    if let name = nameSurname["name"] {
//                        driverModel.name = name
//                    }
//                    
//                    if let surname = nameSurname["surname"] {
//                        driverModel.surname = surname
//                    }
//                    
//                    let dates = extractDates(text: success).sorted(by: { $0 < $1 })
//                    
//                    if dates.count == 3 {
//                        driverModel.driverDate = dates.first
//                        driverModel.startDate = dates[safe: 1]
//                        driverModel.expiredDate = dates[safe: 2]
//                    }
//                    
//                    if let number = extractNumber(text: success) {
//                        driverModel.number = number
//                    }
//                    
//                    print("OKOKOKOKO")
//                    print(driverModel)
//                    completion(.success(driverModel))
//                    
//                case .failure:
//                    completion(.failure(.failedToLoadModel))
//                }
//
//            }
//        }
        
        
        if let detectorModel = CarDocumentRecognizerType.driverLicense.getVNDetectorModel() {
            
            self.detectZones(for: detectorModel, in: image) { [weak self] detected in
                
                guard let cgImage = image.cgImage, let self = self else {
                    completion(.failure(.failedToLoadModel))
                    return
                }
                var resultDetect: [String: String] = [:]
                
                detected.forEach({ observations, label in
                    self.recognizeTextZone(in: cgImage, from: observations, label: label, imageSize: image.size) { label, result in
                        if let result {
                            resultDetect[label] = result
                        }
                    }
                })
                var driverModel = DriverLicenseModel()
                if let name = resultDetect["name"] {
                    driverModel.name = name
                }
                
                if let number = resultDetect["number"] {
                    driverModel.number = number
                }
                
                if let surname = resultDetect["surname"] {
                    driverModel.surname = surname
                }
                
                if let startDate = resultDetect["startDate"]?.toDate(dateForamtter: .simpleFormatter) {
                    driverModel.startDate = startDate
                }
                
                if let endDate = resultDetect["endDate"]?.toDate(dateForamtter: .simpleFormatter) {
                    driverModel.expiredDate = endDate
                }
                
                if let birthday = resultDetect["birthday"]?.toDate(dateForamtter: .simpleFormatter) {
                    driverModel.driverDate = birthday
                }
                
                if let category = resultDetect["category"] {
                    driverModel.category = category
                }
                
                completion(.success(driverModel))
            }
        } else {
            completion(.failure(.failedToLoadModel))
        }
         

        
        
        /*
        recognizeText(from: image) { strings in
            var strings = strings
            strings.removeAll(where: { $0 == "ВОДИТЕЛЬСКОЕ УДОСТОВЕРЕНИЕ" })
            var finded = [String: String]()
            print(strings)
            print("\n\n")
            if let number = CarDocumentTextRecognizer.findFrom(pattern: "^\\d{2} \\d{2} \\d{6}$", in: strings).first?.replacingOccurrences(of: " ", with: "") {
                finded["licenseNumber"] = number
            }
            
            var allDates = CarDocumentTextRecognizer.find(pattern: "\\d{2}.\\d{2}.\\d{4}$", in: strings)
            if let startDate = strings.first(where: { $0.contains("4a") }) {
                if let startDateFinded = CarDocumentTextRecognizer.findFrom(pattern: "\\d{2}\\.\\d{2}\\.\\d{4}", in: [startDate]).first {
                    allDates.append(startDateFinded)
                }
            }
            
            if let endDate = strings.first(where: { $0.contains("4b") }) {
                if let endDateDateFinded = CarDocumentTextRecognizer.findFrom(pattern: "\\d{2}\\.\\d{2}\\.\\d{4}", in: [endDate]).first {
                    allDates.append(endDateDateFinded)
                }
            }
                        
            if allDates.count > 2 {
                var dates = allDates.compactMap({ $0.toDate(dateForamtter: .simpleFormatter) }).sorted()
                dates.removeFirst()
                finded["startDate"] = dates[0].toString(dateForamtter: .simpleFormatter)
                finded["endDate"] = dates[1].toString(dateForamtter: .simpleFormatter)
            }
            
            completion(.success(finded))
        }
         */
    }
    
    func cleanString(_ string: String, type: String) -> String? {
        switch type {
        case "surname", "name":
            let cleaned = string.replacingOccurrences(of: "[^А-Яа-яЁё ]", with: "", options: .regularExpression)
            return cleaned.isEmpty ? nil : cleaned
        default:
            return nil
        }
    }

    func extractFields(from text: String) -> [String: String] {
        var fields = [String: String]()
        
        let patterns = [
            "surname": #"1\.\s*(\S+)"#,
            "name": #"2\.\s*(.*?)\n"#,
        ]
        
        for (field, pattern) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(location: 0, length: text.utf16.count)
                if let match = regex.firstMatch(in: text, options: [], range: range) {
                    if let range = Range(match.range(at: 1), in: text) {
                        let extractedValue = String(text[range])
                        if let cleanedValue = cleanString(extractedValue, type: field) {
                            fields[field] = cleanedValue
                        }
                    }
                }
            }
        }
        
        return fields
    }
    
    func extractDates(text: String) -> [Date] {
        var dates = [Date]()
        let datePattern = #"\b\d{2}\.\d{2}\.\d{4}\b"#
        let regex = try! NSRegularExpression(pattern: datePattern)
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)

        for match in matches {
            let date = (text as NSString).substring(with: match.range)
            if let date = date.toDate(dateForamtter: .simpleFormatter) {
                dates.append(date)
            }
        }
        return dates
    }
    
    func extractNumber(text: String) -> String? {
        let vuPattern = #"\b\d{2}\s?\d{2}\s?\d{6}\b|\b\d{4}\s?\d{6}\b|\b\d{6}\s?\d{4}\b|\b\d{8}\b"#
        let regex = try! NSRegularExpression(pattern: vuPattern)
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)

        for match in matches {
            let vuNumber = (text as NSString).substring(with: match.range)
            return vuNumber
        }
        return nil
    }
}
