//
//  File 2.swift
//  CarDocumentRecognizer
//
//  Created by Astemir Shibzuhov on 12.03.2025.
//

import UIKit
import SwiftyTesseract
import Extensions

public struct STSModel: ConvertibleToDictionary {
    public var vin: String?
    public var plate: String?
    public var number: String?
}

final class STSRecognizer: CarDocumentRecognizer {
    func recognize(image: UIImage, completion: @escaping (Result<ConvertibleToDictionary, DocumentsError>) -> Void) {
//        print("OKOKOKOKOKOKOK")
//        DispatchQueue.main.async {
//            let teseeract = Tesseract(languages: [.russian, .english], dataSource: Bundle.module)
//            guard let imageData = image.pngData() else { return }
//            let result = teseeract.performOCR(on: imageData)
//            switch result {
//                
//            case .success(let text):
//                print(text)
//            case .failure(let failure):
//                print("ERROR")
//            }
//        }
        
        recognizeText(from: image) { array in
            var matchedData = [String: String]()
            if let vin = CarDocumentTextRecognizer.find(pattern: CarDocumentRegularPatterns.vin, in: array).first {
                matchedData["vin"] = vin
            }
            if let plate = CarDocumentTextRecognizer.find(pattern: CarDocumentRegularPatterns.plate, in: array).first {
                matchedData["plate"] = plate
            }
            
            if let numberSts = CarDocumentTextRecognizer.find(pattern: "^\\d{2} \\d{2} \\d{6}$", in: array).first {
                matchedData["number"] = numberSts.replacingOccurrences(of: " ", with: "")
            } else if let numberSts = CarDocumentTextRecognizer.find(pattern: "^\\d{2} \\d{2}$", in: array).first, let secondNumberSts = CarDocumentTextRecognizer.find(pattern: "^\\d{6}$", in: array).first {
                matchedData["number"] = [numberSts, secondNumberSts].joined().replacingOccurrences(of: " ", with: "")
            } else if let numberSts = CarDocumentTextRecognizer.find(pattern: "^\\d{2}$", in: array).first, let secondNumberSts = CarDocumentTextRecognizer.find(pattern: "^\\d{2} \\d{6}$", in: array).first  {
                matchedData["number"] = [numberSts, secondNumberSts].joined().replacingOccurrences(of: " ", with: "")
            } else if let numberSts = CarDocumentTextRecognizer.find(pattern: "^\\d{2} \\d{2} [N] \\d{6}$", in: array).first {
                matchedData["number"] = numberSts.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "N", with: "")
            } else if let numberSts = CarDocumentTextRecognizer.find(pattern: "^\\d{2} \\d{2} Nº \\d{6}$", in: array).first {
                matchedData["number"] = numberSts.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "Nº", with: "")
            } else {
                let numberFirst = CarDocumentTextRecognizer.find(pattern: "^\\d{2}$", in: array)
                
                let numberSecond = CarDocumentTextRecognizer.find(pattern: "^\\d{6}$", in: array)
                
                if let first = numberFirst.first, let second = numberFirst[safe: 1], let third = numberSecond.last {
                    matchedData["number"] = [first, second, third].joined().replacingOccurrences(of: " ", with: "")
                }
            }
            let model = STSModel(vin: matchedData["vin"], plate: matchedData["plate"], number: matchedData["number"])
            if matchedData.isEmpty {
                completion(.failure(.failedToLoadModel))
            } else {
                completion(.success(model))
            }
        }
    }
}
