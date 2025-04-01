//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import UIKit
import CombineCoreData
import Combine
import AppFileManager
import SmartCamera
import CarDocumentRecognizer
import Photos
import CoreData
import Networking
import Extensions

enum DocumentsViewState {
    case loading, loaded(items: [DocumentModel]), error
}

struct DocumentModel  {
    let id: String
    let image: UIImage
    var attributes: [String: Any]
}

protocol DocumentsViewInput: AnyObject {
    func setState(state: DocumentsViewState)
}

protocol DocumentsViewOutput {
    func viewDidLoad()
    func refresh()
    func addDocument()
    func openDocument(with id: String)
}

enum Document {
    static let documentsFolderName = "carDocuments"
}

enum Keys {
    static let documentElementKeys: [String: String] = [
        "startDate":"Дата создания",
        "endDate":"Истекает",
        "name":"Имя",
        "secondName":"Фамилия",
        "number":"Номер",
        "plateNumber": "Гос номер"
    ]
}

final class DocumentsPresenter: DocumentsViewOutput {
    
    weak var view: DocumentsViewInput?
    private let router: DocumentsRouterInput
    private let storageManager: CombineCoreData
    private let fileStorageManager: AppFileManager
    private var cancellables = Set<AnyCancellable>()
    private var selectedDocument: CarDocumentRecognizerType?
    
    init(storageManager: CombineCoreData, fileStorageManager: AppFileManager, view: DocumentsViewInput, router: DocumentsRouterInput) {
        self.view = view
        self.router = router
        self.storageManager = storageManager
        self.fileStorageManager = fileStorageManager
    }
    
    func viewDidLoad() {
        request()
    }
    
    func refresh() {
        
    }
    
    func addDocument() {
        router.openDocumentTypes(action: { [weak self] selected in
            guard let self else { return }
            self.selectedDocument = selected
            self.router.openCamera(delegate: self)
        })
    }
    
    func openDocument(with id: String) {
        self.router.openDocumentDetails(documentId: id)
    }
    
    func request() {
        storageManager.fetchEntities(entity: CarDocument.self)
            .sink(receiveValue: { [weak self] documents in
                guard let self else { return }
                
                let items = documents.compactMap({
                    self.mapToItem(car: $0)
                })
                self.view?.setState(state: .loaded(items: items))
            })
            .store(in: &cancellables)
    }
    
    private func mapToItem(car: CarDocument) -> DocumentModel? {
        let result = self.fileStorageManager.getFile(fileName: car.type)
        switch result {
        case .success(let success):
            if let image = UIImage(data: success) {
                if let attributes = car.attributes, let serialized = try? JSONSerialization.jsonObject(with: attributes) as? [String: Any] {
                    let model = DocumentModel.init(id: car.type, image: image, attributes: serialized)

                    return model
                }
                return nil
            } else {
                return nil
            }
        case .failure:
            return nil
        }
    }
}

extension DocumentsPresenter: SmartCameraDelegate {
    func didFinish(images: [UIImage], error: SmartCameraError?) {
        router.closeTopViewController()
        
        if let selectedDocument {
            guard let image = images.first else { return }
            CarDocumentRecognizerManager.shared.recognize(with: selectedDocument, image: image)
                .mapError({ $0 as Error })
                .flatMap({  [weak self] documentData -> AnyPublisher<(ConvertibleToDictionary, URL), Error> in
                    print(documentData.toDictionary())
                    guard let self, let data = image.jpegData(compressionQuality: 0.9) else { return .fail(error: CoreError.decodeError) }
                    let result = fileStorageManager.saveImageWithReplace(fileName: selectedDocument.id, content: data)
                    switch result {
                    case .success(let fileURL):
                        return .just((documentData, fileURL))
                    case .failure:
                        return .fail(error: CoreError.decodeError)
                    }
                })
                .flatMap({ [weak self] result -> AnyPublisher<(ConvertibleToDictionary, URL), Error> in
                    guard let self else { return .fail(error: CoreError.decodeError) }
                    self.storageManager.removeIfFind(entity: CarDocument.self, predicate: NSPredicate(format: "type == %@", selectedDocument.id))
                    return .just(result)
                })
                .flatMap { [weak self] result -> AnyPublisher<CarDocument, Error> in
                    let documentData = result.0
                    let imageUrl = result.1
                    guard let self else { return .fail(error: CoreError.decodeError) }
                
                    return self.storageManager.createEntity(entity: CarDocument.self) { object in
                        object.id = .init()
                        object.type = selectedDocument.id
                        object.name = selectedDocument.title
                        object.imagePath = imageUrl.absoluteString
                        object.attributes = documentData.toDictionary().toJsonData()
                        if let driver = documentData as? DriverLicenseModel, let date = driver.expiredDate {
                            object.expiredDate = date
                        }
                    }
                    .mapError({ $0 as Error })
                    .eraseToAnyPublisher()
                }
                .sink(receiveError: { error in
                    print("Показать alert ошибки")
                }, receiveValue: { [weak self] value in
                    self?.request()
                    print(value)
                })
                .store(in: &cancellables)
        }
         
    }
    
    // ПРОСТО ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ
    private func savePhotos(images: [UIImage]) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                // Разрешение получено
                PHPhotoLibrary.shared().performChanges({
                        for image in images {
                            PHAssetChangeRequest.creationRequestForAsset(from: image)
                        }
                    }, completionHandler: { success, error in
                        if success {
                            print("Изображения сохранены в галерею")
                        } else {
                            print("Ошибка при сохранении: \(error?.localizedDescription ?? "неизвестно")")
                        }
                    })
            case .denied, .restricted, .notDetermined:
                print("Нет доступа к фото")
            @unknown default:
                break
            }
        }
        return
    }
}
