import UIKit
import AVFoundation

public protocol ReceiptReaderDelegate: AnyObject {
    func didReadReceipt(with result: Result<String, ReceiptError>)
}

public enum ReceiptError: Error {
    case invalidQRFormat
    case missingRequiredFields
}

public final class ReceiptReaderViewController: UIViewController {
    
    // MARK: - UI Elements
    private let previewView = UIView()
    private lazy var cancelButton = UIButton()
    private var captureSession: AVCaptureSession!
    public weak var delegate: ReceiptReaderDelegate?
    public var withCancelButton: Bool = false
    public var needDissmisAfterRead: Bool = true
    private var isScanningCompleted = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCaptureSession()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отменить", for: .normal)
        
        // Настройка previewView
        previewView.backgroundColor = .black
        previewView.layer.cornerRadius = 12
        previewView.clipsToBounds = true
        
        
        // Расположение элементов
        let stackView = UIStackView(arrangedSubviews: [previewView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        if self.withCancelButton {
            view.addSubview(cancelButton)
        }
        cancelButton.addAction(.init(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        if withCancelButton {
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor),
            
        ])
    }
    
    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - QR Code Processing
    private func processQRCode(_ string: String) {
        parseQRCheck(string)
    }
    
    func parseQRCheck(_ qrString: String) {
        guard !isScanningCompleted else { return }
        isScanningCompleted = true
        defer {
            if self.needDissmisAfterRead {
                if navigationController == nil {
                    self.dismiss(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        // Проверяем, что это похоже на QR-код чека
        guard qrString.contains("t=") &&
                qrString.contains("fn=") &&
                qrString.contains("i=") &&
                qrString.contains("fp=") else {
            delegate?.didReadReceipt(with: .failure(.invalidQRFormat))
            return
        }
        
        delegate?.didReadReceipt(with: .success(qrString))
    }}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ReceiptReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           metadataObject.type == .qr,
           let stringValue = metadataObject.stringValue {
            
            // Остановка в фоновом потоке
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.stopRunning()
                
                DispatchQueue.main.async {
                    self?.processQRCode(stringValue)
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
        }
    }
    
    private func setupCaptureSession() {
        // Создаем сессию в фоновом потоке
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession = AVCaptureSession()
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
                  self.captureSession.canAddInput(videoInput) else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Камера недоступна")
                }
                return
            }
            
            self.captureSession.addInput(videoInput)
            
            let metadataOutput = AVCaptureMetadataOutput()
            guard self.captureSession.canAddOutput(metadataOutput) else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Не удалось настроить сканирование")
                }
                return
            }
            
            self.captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                previewLayer.frame = self.previewView.bounds
                previewLayer.videoGravity = .resizeAspectFill
                self.previewView.layer.addSublayer(previewLayer)
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession.startRunning()
                }
            }
        }
    }
}
