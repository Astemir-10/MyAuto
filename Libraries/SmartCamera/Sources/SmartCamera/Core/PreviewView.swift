import UIKit
import AVFoundation

final class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        videoPreviewLayer.videoGravity = .resizeAspectFill
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBoundingBox(rect: CGRect) {
        let borderLayer = CALayer()
        borderLayer.frame = rect
        borderLayer.borderColor = UIColor.red.cgColor
        borderLayer.borderWidth = 2.0
        
        // Очищаем старые рамки
        videoPreviewLayer.sublayers?.removeAll(where: { $0.name == "documentLayer" })
        
        borderLayer.name = "documentLayer"
        videoPreviewLayer.addSublayer(borderLayer)
    }
}
