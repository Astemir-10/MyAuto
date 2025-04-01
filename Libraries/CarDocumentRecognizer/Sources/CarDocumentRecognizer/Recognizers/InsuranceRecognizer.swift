//
//  File 4.swift
//  CarDocumentRecognizer
//
//  Created by Astemir Shibzuhov on 12.03.2025.
//

import UIKit
import Extensions

final class InsuranceRecognizer: CarDocumentRecognizer {
    func recognize(image: UIImage, completion: @escaping (Result<ConvertibleToDictionary, DocumentsError>) -> Void) {
        completion(.failure(.failedToLoadModel))
    }
}
