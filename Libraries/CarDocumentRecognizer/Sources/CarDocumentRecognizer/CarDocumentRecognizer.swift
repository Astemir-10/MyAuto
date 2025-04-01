import UIKit
import Combine
import Vision
import CreateML
import Extensions


public protocol CarDocumentRecognizer {
    func recognize(image: UIImage, completion: @escaping (Result<ConvertibleToDictionary, DocumentsError>) -> Void)
    func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void)
}

extension CarDocumentRecognizer {
    func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                print("Ошибка распознавания текста: \(error!.localizedDescription)")
                completion([])
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([])
                return
            }
            
            // Получаем распознанный текст
            let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
                        
            completion(recognizedStrings)
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en", "ru"] // Укажи нужный язык
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
            
        }
        
    }
    
    func detectZones(
        for model: VNCoreMLModel,
        in image: UIImage,
        completion: @escaping ([(observation: VNRecognizedObjectObservation, label: String)]) -> Void
    ) {
        guard let cgImage = image.cgImage else { return }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }

            let labeledResults = results.compactMap { observation -> (VNRecognizedObjectObservation, String)? in
                guard let label = observation.labels.first?.identifier, let confidence = observation.labels.first?.confidence, confidence > 0.86 else { return nil }
                return (observation, label)
            }

            completion(labeledResults)
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    func recognizeTextZone(
        in image: CGImage,
        from observation: VNRecognizedObjectObservation,
        label: String,
        imageSize: CGSize,
        completion: @escaping (String, String?) -> Void // label + text
    ) {
        let boundingBox = observation.boundingBox

        let rect = CGRect(
            x: boundingBox.minX * CGFloat(image.width),
            y: (1 - boundingBox.maxY) * CGFloat(image.height),
            width: boundingBox.width * CGFloat(image.width),
            height: boundingBox.height * CGFloat(image.height)
        )

        guard let cropped = image.cropping(to: rect) else {
            completion(label, nil)
            return
        }

        let request = VNRecognizeTextRequest { req, _ in
            let text = (req.results as? [VNRecognizedTextObservation])?
                .first?.topCandidates(1).first?.string
            completion(label, text)
        }

        let handler = VNImageRequestHandler(cgImage: cropped, options: [:])
        try? handler.perform([request])
    }}

enum CarDocumentTextRecognizer {
    static func find(pattern: String, in array: [String]) -> [String] {
        var finded = [String]()
        for string in array {
            if let _ = string.range(of: pattern, options: .regularExpression) {
                finded.append(string)
            }
        }
        return finded
    }
    
    static func findFrom(pattern: String, in array: [String]) -> [String] {
        var finded = [String]()
        for string in array {
            if let findedString = findMatch(in: string, pattern: pattern) {
                finded.append(findedString)
            }
        }
        return finded
    }

    static private func findMatch(in text: String, pattern: String) -> String? {
        do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let range = NSRange(text.startIndex..<text.endIndex, in: text)
                
                if let match = regex.firstMatch(in: text, options: [], range: range) {
                    return String(text[Range(match.range, in: text)!])
                }
            } catch {
                print("Ошибка при создании регулярного выражения: \(error)")
            }
            return nil
    }
}

enum CarDocumentRegularPatterns {
    static let vin = "[A-HJ-NPR-Z0-9]{17}"
    static let plate = "^[АВЕКМНОРСТУХ]{1}\\d{3}[АВЕКМНОРСТУХ]{2}\\d{2,3}$"
}

public enum CarDocumentRecognizerType: CaseIterable {
    case pts, sts, driverLicense, insurance
    
    public var title: String {
        switch self {
        case .pts:
            "ПТС"
        case .sts:
            "СТС"
        case .driverLicense:
            "Водительское удостоверение"
        case .insurance:
            "ОСАГО"
        }
    }
    
    public var id: String {
        switch self {
        case .pts:
            "pts"
        case .sts:
            "sts"
        case .driverLicense:
            "driverLicense"
        case .insurance:
            "insurance"
        }
    }
    
    var detectorName: String {
        switch self {
        case .pts:
            return "PTSDetector"
        case .sts:
            return "STSDetector"
        case .driverLicense:
            return "DriverLicenseDetector"
        case .insurance:
            return "InsuranceDetector"
        }
    }
    
    func getDetectorModel() -> MLModel? {
        if let url = Bundle.module.url(forResource: detectorName, withExtension: "mlmodelc") {
            return try? MLModel(contentsOf: url)
        }
        return nil
    }
    
    func getVNDetectorModel() -> VNCoreMLModel? {
        if let mlModel = getDetectorModel() {
            return try? VNCoreMLModel(for: mlModel)
        }
        return nil
    }
}

public enum DocumentsError: Error {
    case failedToLoadModel
}

public final class CarDocumentRecognizerManager {
    public static let shared = CarDocumentRecognizerManager()
    
    private init() { }
    
    public func recognize(with documentType: CarDocumentRecognizerType, image: UIImage) -> AnyPublisher<ConvertibleToDictionary, DocumentsError> {
        let recognizer: CarDocumentRecognizer

        switch documentType {
        case .pts:
            recognizer = PTSRecognizer()
        case .sts:
            recognizer = STSRecognizer()
        case .driverLicense:
            recognizer = DriverLicenseRecognizer()
        case .insurance:
            recognizer = InsuranceRecognizer()
        }
        
        return Future<ConvertibleToDictionary, DocumentsError> { primise in
            recognizer.recognize(image: image) { result in
                switch result {
                case .success(let documentData):
                    primise(.success(documentData))
                case .failure(let error):
                    primise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}


