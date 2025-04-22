//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import DesignKit
import UIKit
import CarScannerCore

final class CarScannerViewController: CommonViewController {
    
    var output: CarScannerViewOutput!
    private lazy var connectButton = Button().forAutoLayout()
    private lazy var outputButton = Button().forAutoLayout()
    private lazy var configureButton = Button().forAutoLayout()
    private lazy var commandsButton = Button().forAutoLayout()
    private lazy var copyCommandsButton = Button().forAutoLayout()
    private lazy var liveSessionButton = Button().forAutoLayout()
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    private lazy var statusConnectedLabel: UILabel = UILabel().forAutoLayout()
    private lazy var statusTransportLabel: UILabel = UILabel().forAutoLayout()
    private lazy var speedLabel: UILabel = UILabel().forAutoLayout()
    private lazy var rpmLabel: UILabel = UILabel().forAutoLayout()
    private lazy var availableCommandsLabel: UILabel = UILabel().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(connectButton)
        connectButton.addConstraintToSuperView([.top(12), .leading(12), .trailing(-12)], withSafeArea: true)
        connectButton.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -12).activated()
        connectButton.primaryText = "Подключить"
        connectButton.setSize(.medium)
        connectButton.addAction(.init(handler: { [weak self] _ in
            self?.output.didTapConnect()
        }), for: .touchUpInside)
        scrollView.addConstraintToSuperView([.bottom(0), .leading(0), .trailing(0)], withSafeArea: true)
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        scrollView.addSubview(contentStackView)
        contentStackView.addFourNullConstraintToSuperView()
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .leading
        hStack.distribution = .equalCentering
        hStack.addArrangedSubviews([statusConnectedLabel, statusTransportLabel])
        contentStackView.addArrangedSubview(outputButton)
        contentStackView.addArrangedSubview(configureButton)
        contentStackView.addArrangedSubview(hStack)
        configureButton.primaryText = "Конфигурировать"
        configureButton.addAction(.init(handler: { [weak self] _ in
            self?.output.configure()
        }), for: .touchUpInside)
        
        outputButton.primaryText = "Консоль"
        outputButton.addAction(.init(handler: { [weak self] _ in
            self?.output.openConsole()
        }), for: .touchUpInside)

        liveSessionButton.primaryText = "Live"
        liveSessionButton.addAction(.init(handler: { [weak self] _ in
            self?.output.setLiveSession()
        }), for: .touchUpInside)
        contentStackView.addArrangedSubview(liveSessionButton)
        self.contentStackView.addArrangedSubview(commandsButton)
        contentStackView.addArrangedSubview(copyCommandsButton)
        contentStackView.addArrangedSubview(speedLabel)
        contentStackView.addArrangedSubview(rpmLabel)
        contentStackView.addArrangedSubview(availableCommandsLabel)
        contentStackView.spacing = 12
        
        copyCommandsButton.primaryText = "Copy"
        copyCommandsButton.addAction(.init(handler: { [weak self] _ in
            UIPasteboard.general.string = self?.availableCommandsLabel.text
        }), for: .touchUpInside)
        
        commandsButton.primaryText = "Команды"
        commandsButton.addAction(.init(handler: { [weak self] _ in
            Task {
                await self?.output.didTapCommands()
            }
        }), for: .touchUpInside)
        
        output.setup()
        availableCommandsLabel.text = "Commands"
        availableCommandsLabel.numberOfLines = 0
    }
    
    @objc
    private func didTapCommands() {
        UIPasteboard.general.string = availableCommandsLabel.text
    }
}

extension CarScannerViewController: CarScannerViewInput {
    func setAvailableCommandsResult(_ result: String) {
        DispatchQueue.main.async { [weak self] in
            self?.availableCommandsLabel.text = result
        }
    }
    
    func setSpeed(speed: String) {
        speedLabel.text = speed
    }
    
    func setRPM(rpm: String) {
        rpmLabel.text = rpm
    }
    
    func setConnectionState(_ state: CarScannerCore.ConnectionState) {
        switch state {
        case .disconnected:
            self.statusConnectedLabel.text = "disconnected"
        case .connecting:
            self.statusConnectedLabel.text = "connecting"
        case .connected:
            self.statusConnectedLabel.text = "connected"
        case .disconnecting:
            self.statusConnectedLabel.text = "disconnecting"
        case .error(let error):
            self.statusConnectedLabel.text = "\(error.localizedDescription)"
        }
    }
    
    func setTransportState(_ state: CarScannerCore.TransportState) {
        switch state {
        case .poweredOn:
            self.statusTransportLabel.text = "poweredOn"
        case .poweredOff:
            self.statusTransportLabel.text = "poweredOff"
        case .unauthorized:
            self.statusTransportLabel.text = "unauthorized"
        case .unsupported:
            self.statusTransportLabel.text = "unsupported"
        case .unknown:
            self.statusTransportLabel.text = "unknown"
        case .failed(let error):
            self.statusTransportLabel.text = "\(error.localizedDescription)"
        }
    }
    
    func setCommand(command: String) {
        let label = UILabel()
        label.text = command
        contentStackView.addArrangedSubview(label)
    }
    
    
}
