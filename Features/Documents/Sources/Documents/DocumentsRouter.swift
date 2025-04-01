//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import Foundation
import Architecture
import SmartCamera
import CarDocumentRecognizer

protocol DocumentsRouterInput: RouterInput {
    func openDocumentDetails(documentId: String)
    func openCamera(delegate: SmartCameraDelegate)
    func openDocumentTypes(action: @escaping (CarDocumentRecognizerType) -> ())
}

final class DocumentsRouter: DocumentsRouterInput {
    
    weak var transitionHandler: TransitionHandler!
    
    func openDocumentDetails(documentId: String) {
        let documentDetails = DocumentDetailsAssembly.assemble(documentId: documentId)
        transitionHandler.push(documentDetails)
    }
    
    func openCamera(delegate: SmartCameraDelegate) {
        let smartCamera = SmartCameraViewController()
        smartCamera.delegate = delegate
        transitionHandler.present(smartCamera)
    }
    
    func openDocumentTypes(action: @escaping (CarDocumentRecognizerType) -> ()) {
        let vc = DocumentTypesSheet()
        vc.sheetPresentationController?.detents = [.medium()]
        vc.didSelectAction = action
        transitionHandler.present(vc)
    }
}
