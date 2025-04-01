//
//  File.swift
//  CarDocumentRecognizer
//
//  Created by Astemir Shibzuhov on 12.03.2025.
//

import UIKit
import Vision
import Extensions

final class PTSRecognizer: CarDocumentRecognizer {

    
    func recognize(image: UIImage, completion: @escaping (Result<ConvertibleToDictionary, DocumentsError>) -> Void) {
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
            

//            completion(.success(matchedData))
        }

//        if let detectorModel = CarDocumentRecognizerType.pts.getVNDetectorModel() {
//            self.detectZones(for: detectorModel, in: image) { [weak self] detected in
//                guard let cgImage = image.cgImage, let self = self else { return }
//                print("DETECTED AS")
//                detected.forEach({
//                    self.recognizeTextZone(in: cgImage, from: $0, imageSize: image.size) { result in
//                        print(result)
//                    }
//                })
//            }
//        } else {
//            completion(.failure(.failedToLoadModel))
//        }
        
//        completion(.failure(.failedToLoadModel))
//        Bundle.module.url(forResource: "YourModel", withExtension: "mlmodelc")!
        
    }

}
