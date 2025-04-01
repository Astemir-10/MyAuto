//
//  File.swift
//  Networking
//
//  Created by Astemir Shibzuhov on 26.10.2024.
//

import UIKit
import VisionKit
import AVFoundation

public enum SmartCameraError: Error {
    case commonError
}

public protocol SmartCameraDelegate: AnyObject {
    func didFinish(images: [UIImage], error: SmartCameraError?)
}

public final class SmartCameraViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    private lazy var documentCameraViewController = VNDocumentCameraViewController()
    public weak var delegate: SmartCameraDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildVC(documentCameraViewController)
        documentCameraViewController.delegate = self
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount > 0 else { return }
        
        var images = [UIImage]()
        
        for i in 0..<scan.pageCount {
            images.append(scan.imageOfPage(at: i))
        }
        
        delegate?.didFinish(images: images, error: nil)
    }
}

extension UIViewController {
    func addChildVC(_ vc: UIViewController) {
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        vc.didMove(toParent: self)
    }
}

/*
public final class SmartCameraViewController: UIViewController, CaptureViedeoDelegateOutput {
    public weak var delegate: SmartCameraDelegate?
    private lazy var captureVideoPreviewView: PreviewView = .init(frame: .zero)
    private var captureSessionManager: CaptureSessionManager!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        captureVideoPreviewView.translatesAutoresizingMaskIntoConstraints = false
        
        captureSessionManager = .init()
        captureSessionManager.delegate = self
        captureVideoPreviewView.videoPreviewLayer.session = captureSessionManager.session
        self.view.addSubview(captureVideoPreviewView)
        captureVideoPreviewView.videoPreviewLayer.connection?.videoOrientation = .portrait
        NSLayoutConstraint.activate([
            captureVideoPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            captureVideoPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            captureVideoPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            captureVideoPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func didGetLayerRect(rect: CGRect) {
        captureVideoPreviewView.drawBoundingBox(rect: rect)
    }
    
}
*/


