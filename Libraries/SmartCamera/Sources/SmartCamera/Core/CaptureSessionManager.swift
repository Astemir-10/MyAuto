import AVFoundation
import UIKit
import Vision


final class CaptureSessionManager {
    let session: AVCaptureSession
    weak var delegate: CaptureViedeoDelegateOutput? {
        didSet {
            bufferDelegate.output = delegate
        }
    }
    private let bufferDelegate: CaptureViedeoDataSAmpleVideoDelegate
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    
    init() {
        self.session = .init()
        bufferDelegate = .init()
        bufferDelegate.output = delegate
        configure()
    }
    
    private func configure() {
        if let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device) {
            session.addInput(input)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(bufferDelegate, queue: DispatchQueue(label: "videoBuffer"))
            session.sessionPreset = .hd4K3840x2160
            session.addOutput(output)
            session.commitConfiguration()
            backgroundQueue.async { [weak self] in
                self?.session.startRunning()
            }
        }
    }
}

protocol CaptureViedeoDelegateOutput: AnyObject {
    func didGetLayerRect(rect: CGRect)
}

final class CaptureViedeoDataSAmpleVideoDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    weak var output: CaptureViedeoDelegateOutput?
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = VNDetectDocumentSegmentationRequest { [weak self] request, error in
            if let error {
                print("Ошибка обработки: \(error.localizedDescription)")
                return
            }
            
            guard let results = request.results?.compactMap({ $0 as? VNRectangleObservation }),
                  let document = results.first,
                  let self else {
                print("Не найдено документов")
                return
            }
            
            let width = CVPixelBufferGetWidth(buffer)
            let height = CVPixelBufferGetHeight(buffer)
            
            if width <= 0 || height <= 0 {
                print("Ошибка: некорректный imageSize (\(width) x \(height))")
                return
            }
            
            let imageSize = CGSize(width: width, height: height)
            //            let rect = self.convertToCGRect(observation: document, imageSize: imageSize)
            
            
            let layerRect = self.convertToLayerRect(observation: document, imageSize: imageSize, previewSize: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            DispatchQueue.main.async {
                self.output?.didGetLayerRect(rect: layerRect)
            }
            
        }
        
        request.revision = VNDetectDocumentSegmentationRequestRevision1
        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, options: [:])
        try? handler.perform([request])
    }
    
    private func convertToCGRect(observation: VNRectangleObservation, imageSize: CGSize) -> CGRect {
        let x = observation.topLeft.x * imageSize.width
        let y = (1 - observation.topLeft.y) * imageSize.height  // Инвертируем Y
        let width = abs((observation.topRight.x - observation.topLeft.x) * imageSize.width)
        let height = abs((observation.bottomLeft.y - observation.topLeft.y) * imageSize.height)
        
        print("Конвертация: x = \(x), y = \(y), width = \(width), height = \(height)")
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func convertToLayerRect(observation: VNRectangleObservation, imageSize: CGSize, previewSize: CGSize) -> CGRect {
        // Получаем нормализованные координаты Vision
        let topLeft = observation.topLeft
        let topRight = observation.topRight
        let bottomLeft = observation.bottomLeft
        let bottomRight = observation.bottomRight
        
        // Преобразуем их в пиксельные координаты
        let x1 = topLeft.x * imageSize.width
        let y1 = (1 - topLeft.y) * imageSize.height // инвертируем Y
        
        let x2 = topRight.x * imageSize.width
        let y2 = (1 - topRight.y) * imageSize.height
        
        let x3 = bottomLeft.x * imageSize.width
        let y3 = (1 - bottomLeft.y) * imageSize.height
        
        let x4 = bottomRight.x * imageSize.width
        let y4 = (1 - bottomRight.y) * imageSize.height
        
        // Вычисляем минимальные и максимальные значения координат для создания прямоугольника
        let minX = min(x1, x2, x3, x4)
        let minY = min(y1, y2, y3, y4)
        let maxX = max(x1, x2, x3, x4)
        let maxY = max(y1, y2, y3, y4)
        
        // Получаем ширину и высоту прямоугольника
        let width = maxX - minX
        let height = maxY - minY
        
        // Масштабируем размер для отображения на экране
        let scaleX = previewSize.width / imageSize.width
        let scaleY = previewSize.height / imageSize.height
        
        // Преобразуем координаты с учетом масштабирования
        let newX = minX * scaleX
        let newY = minY * scaleY
        let newWidth = width * scaleX
        let newHeight = height * scaleY
        
        print("Layer rect: x=\(newX), y=\(newY), width=\(newWidth), height=\(newHeight)")
        
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
}


