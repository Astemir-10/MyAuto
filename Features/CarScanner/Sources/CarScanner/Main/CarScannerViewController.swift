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
    
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    private lazy var noConnectionLabel: UILabel = UILabel().forAutoLayout()
    
    private lazy var connectButton: Button = Button(frame: .zero, primaryAction: .init(handler: { [weak self] _ in
        self?.output.didTapConnect()
    }))
    
    private lazy var scannerInfoStackView: UIStackView = UIStackView()
    private lazy var scannerNameLabel: UILabel =  {
        let lbl = UILabel().forAutoLayout()
        lbl.font = .appFonts.secondaryLarge
        lbl.textColor = .appColors.text.primary
        return lbl
    }()
    private lazy var scannerStateLabel: UILabel = {
        let lbl = UILabel().forAutoLayout()
        lbl.font = .appFonts.secondaryLarge
        lbl.textColor = .appColors.text.primary
        return lbl
    }()
    
    private lazy var indicatorsStackView: UIStackView = {
        let stackView = UIStackView().forAutoLayout()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - RPM
    private lazy var rpmNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Обороты двигателя"
        return lbl.forAutoLayout()
    }()
    private lazy var rpmLabel: UILabel = {
        let lbl = UILabel()
        return lbl.forAutoLayout()
    }()
    
    // MARK: - Speed
    private lazy var speedNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Скорость"
        return lbl.forAutoLayout()
    }()
    private lazy var speedLabel: UILabel = {
        let lbl = UILabel()
        return lbl.forAutoLayout()
    }()
    
    // MARK: - Fuel
    private lazy var fuelNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Уровень топлива"
        return lbl.forAutoLayout()
    }()
    private lazy var fuelLabel: UILabel = {
        let lbl = UILabel()
        return lbl.forAutoLayout()
    }()
    
    // MARK: - Coplant Temperature
    private lazy var coplantNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Температура ох. жидкости"
        return lbl.forAutoLayout()
    }()
    private lazy var coplantLabel: UILabel = {
        let lbl = UILabel()
        return lbl.forAutoLayout()
    }()
    
    // MARK: - Engine Load
    private lazy var engineLoadNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Нагрузка на двигатель"
        return lbl.forAutoLayout()
    }()
    private lazy var engineLoadLabel: UILabel = {
        let lbl = UILabel()
        return lbl.forAutoLayout()
    }()
    
    // MARK: - Power Reserve
    private lazy var powerReserveNameLabel: UILabel = {
        let lbl = UILabel()
        return lbl.forAutoLayout()
    }()
    private lazy var powerReserveLabel: UILabel = {
        let lbl = UILabel()
        return lbl.forAutoLayout()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.setup()
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = .init(title: "Подключить", style: .plain, target: self, action: #selector(didTapConnect))
        scrollView.alwaysBounceVertical = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Сканер"
        view.addSubview(scrollView)
        scrollView.addConstraintToSuperView([.top(8), .bottom(-8), .leading(8), .trailing(-8)], withSafeArea: true)
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        scrollView.addSubview(contentStackView)
        contentStackView.addFourNullConstraintToSuperView()

        scannerInfoStackView.axis = .vertical
        scannerInfoStackView.spacing = 8
        scannerInfoStackView.addArrangedSubview(scannerNameLabel)
        scannerInfoStackView.addArrangedSubview(scannerStateLabel)
        
        contentStackView.addArrangedSubview(scannerInfoStackView)
        contentStackView.addArrangedSubview(indicatorsStackView)
        indicatorsStackView.spacing = 12
        indicatorsStackView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).activated()
        indicatorsStackView.addArrangedSubview(makePairCard(firstCard: [speedNameLabel, speedLabel],
                                                            secondCard: [rpmNameLabel, rpmLabel]))
        indicatorsStackView.addArrangedSubview(makePairCard(firstCard:  [engineLoadNameLabel, engineLoadLabel],
                                                            secondCard: [coplantNameLabel, coplantLabel]))
//        indicatorsStackView.addArrangedSubview(makePairCard(firstCard: [powerReserveNameLabel, powerReserveLabel],
//                                                            secondCard: fuelNameLabel, fuelLabel]))
        indicatorsStackView.arrangedSubviews.forEach({
            $0.widthAnchor.constraint(equalTo: indicatorsStackView.widthAnchor).activated()
            ($0 as? UIStackView)?.arrangedSubviews.forEach({ card in
                card.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).activated()
            })
        })
    }
    
    private func makePairCard(firstCard: [UILabel], secondCard: [UILabel]) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        if let nameLabel = firstCard[safe: 0], let valueLabel = firstCard[safe: 1] {
            stackView.addArrangedSubview(makeCard(nameLabel: nameLabel, valueLabel: valueLabel))
        }
        
        if let nameLabel = secondCard[safe: 0], let valueLabel = secondCard[safe: 1] {
            stackView.addArrangedSubview(makeCard(nameLabel: nameLabel, valueLabel: valueLabel))
        }
        
        return stackView
    }
    
    @objc
    private func didTapConnect() {
        output.didTapConnect()
    }
    
    private func makeCard(nameLabel: UILabel, valueLabel: UILabel) -> UIView {
        let cardView = UIView().forAutoLayout()
        cardView.backgroundColor = .appColors.ui.primaryAlternative
        cardView.layer.cornerRadius = 10
        cardView.addSubviews(nameLabel, valueLabel)
        nameLabel.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8)])
        valueLabel.addConstraintToSuperView([.bottom(-8), .leading(8), .trailing(-8)])
        nameLabel.bottomAnchor.constraint(equalTo: valueLabel.topAnchor, constant: -8).activated()
        
        nameLabel.font = .appFonts.secondaryNeutral
        nameLabel.textColor = .appColors.text.primary
        valueLabel.font = .appFonts.neutralMedium
        valueLabel.textColor = .appColors.text.primary
        
        return cardView
    }
    
    @objc
    private func didTapCommands() {
//        UIPasteboard.general.string = availableCommandsLabel.text
    }
}

extension CarScannerViewController: CarScannerViewInput {
    func setLiveData(_ data: [LiveData]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            data.forEach({
                switch $0 {
                case .speed(let speed):
                    self.speedLabel.text = speed
                case .rpm(let rpm):
                    self.rpmLabel.text = rpm
                case .engineLoad(let engine):
                    self.engineLoadLabel.text = engine
                case .fuel(let fuel):
                    self.fuelLabel.text = fuel
                case .coplantTemperature(let colplant):
                    self.coplantLabel.text = colplant
                case .powerReserve(let reverse):
                    self.powerReserveLabel.text = reverse
                }
            })

        }
    }
    
    func setAvailableCommandsResult(_ result: String) {
        DispatchQueue.main.async { [weak self] in
//            self?.availableCommandsLabel.text = result
        }
    }
    
    func setSpeed(speed: String) {
        speedLabel.text = speed
    }
    
    func setRPM(rpm: String) {
        rpmLabel.text = rpm
    }
    
    func setConnectionState(model: OBDModel) {
        
        self.scannerNameLabel.text = model.name
        switch model.connectionState {
        case .disconnected:
            self.scannerStateLabel.text = "Не подключено"
        case .connecting:
            self.scannerStateLabel.text = "Подключается..."
        case .connected:
            self.scannerStateLabel.text = "Подключено"
        case .disconnecting:
            self.scannerStateLabel.text = "Отключается..."
        case .error(let error):
            self.scannerStateLabel.text = "\(error.localizedDescription)"
        case .ready:
            break
        }
    }
    
    func setTransportState(_ state: CarScannerCore.TransportState) {
    }
    
    func setCommand(command: String) {
    }
}
