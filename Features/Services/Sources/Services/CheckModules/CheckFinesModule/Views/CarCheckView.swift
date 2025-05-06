//
//  File.swift
//  Services
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import UIKit
import DesignKit
import  AppServices

protocol CheckViewOutput: AnyObject {
    func didTapStart(data: [String: String])
}

protocol CheckViewInput {
    var delegate: CheckViewOutput? { get set }
    func setModel(model: Any)
}

final class CarCheckView: UIView, CheckViewInput, UITextFieldDelegate {
    
    private lazy var vinTextField: TextField = {
        let textField = TextField().forAutoLayout()
        textField.placeholder = "VIN"
        return textField
    }()
    private lazy var topView = UIView().forAutoLayout()
    private lazy var bottomStackView = UIStackView().forAutoLayout()
    private lazy var activationButton = Button().forAutoLayout()
    weak var delegate: CheckViewOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func setupUI() {
        vinTextField.backgroundColor = .appColors.ui.primaryAlternativeSecondary
        vinTextField.returnKeyType = .done
        vinTextField.configure { config in
            config.cornerRadius = 10
        }
        addSubviews(topView, bottomStackView)
        topView.addConstraintToSuperView([.top(12), .leading(12), .trailing(-12)])
        bottomStackView.addConstraintToSuperView([.bottom(-12), .leading(12), .trailing(-12)])
        topView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -20).activated()
        topView.addSubview(vinTextField)
        
        topView.addSubview(activationButton)
        topView.layer.cornerRadius = 12
        topView.backgroundColor = .appColors.ui.primaryAlternative
        vinTextField.addConstraintToSuperView([.top(12), .leading(12), .trailing(-12)])
        vinTextField.delegate = self
        vinTextField.setSize(height: 40)
        activationButton.setSize(.medium)
        activationButton.setBackgroundStyle(.primary)
        activationButton.addAction(.init(handler: { [weak self] _ in
            if let vin = self?.vinTextField.text, vin != "" {
                self?.delegate?.didTapStart(data: ["vin": vin])
            }
            self?.endEditing(true)
        }), for: .touchUpInside)
        
        activationButton.addConstraintToSuperView([.bottom(-12), .leading(12), .trailing(-12)])
        activationButton.topAnchor.constraint(equalTo: vinTextField.bottomAnchor, constant: 20).activated()
        activationButton.primaryText = "Найти"
    }
    
    func setModel(model: Any) {
        if let model = model as? CarRegisterResponse {
            bottomStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            let view = makeCarCardView(carData: model.requestResult)
            bottomStackView.addArrangedSubview(view)
            view.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor).activated()
        }
    }
    
    private func makeCarCardView(carData: CarRegister) -> UIView {
        let view = UIStackView().forAutoLayout()
        view.axis = .vertical
        view.spacing = 4
        var carInfoArray = [(name: String, value: String)]()
        carInfoArray.append((name: "Модель", value: carData.vehicleBrandModel))
        carInfoArray.append((name: "Год выпуска", value: carData.vehicleReleaseYear))
        if let power = Double(carData.vehicleEnginePower) {
            carInfoArray.append((name: "Мощность", value: power.format(.horsepower)))
        }
        
        carInfoArray.append((name: "Цвет кузова", value: carData.vehicleBodyColor))
        
        if let volume = Double(carData.vehicleEnclosedVolume) {
            carInfoArray.append((name: "Объем", value: volume.format(.liters)))
        }
        carInfoArray.append((name: "Экологический класс", value: carData.vehicleEcoClass))
        carInfoArray.append((name: "Регистрация в РФ", value: carData.reestrStatus))
        carInfoArray.forEach({
            let stackView = UIStackView().forAutoLayout()
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.distribution = .fill
            stackView.alignment = .fill
            let nameLabel = UILabel()
            nameLabel.text = $0.name
            
            let valueLabel = UILabel()
            valueLabel.text = $0.value
            valueLabel.textAlignment = .right
            stackView.addArrangedSubviews(nameLabel, valueLabel)
            view.addArrangedSubview(stackView)
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor).activated()
        })
        
        let ownersView = makeOwnersView(owners: carData.periods)
        view.addArrangedSubview(ownersView)
        ownersView.widthAnchor.constraint(equalTo: view.widthAnchor).activated()
        return view
    }
    
    private func makeOwnersView(owners: [CarRegisterOwnershipPeriod]) -> UIView {
        let view = UIView().forAutoLayout()
        let stackView = UIStackView().forAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).activated()
        stackView.addConstraintToSuperView([.top(20), .leading(0), .trailing(0), .bottom(0)])
        owners.forEach({
            let ownerView = makeOwnerView(owner: $0)
            stackView.addArrangedSubview(ownerView)
            ownerView.widthAnchor.constraint(equalTo: stackView.widthAnchor).activated()
        })
        return view
    }
    
    private func makeOwnerView(owner: CarRegisterOwnershipPeriod) -> UIView {
        let view = UIView().forAutoLayout()
        view.layer.cornerRadius = 8
        view.backgroundColor = .appColors.ui.primaryAlternative
        let ownLabel = UILabel()
        view.addSubview(ownLabel)
        ownLabel.text = owner.ownerType
        ownLabel.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8)])
        
        let stackView = UIStackView().forAutoLayout()
        stackView.spacing = 8
        stackView.axis = .vertical
        let startLabel = UILabel()
        startLabel.text = "Начало: \(owner.startDate)"
        
        let endLabel = UILabel()
        if owner.endDate == "" {
            endLabel.text = "По текущее время"
        }
        stackView.addArrangedSubviews(startLabel, endLabel)
        view.addSubview(stackView)
        stackView.addConstraintToSuperView([.bottom(-8), .leading(8), .trailing(-8)])
        stackView.topAnchor.constraint(equalTo: ownLabel.bottomAnchor, constant: 12).activated()
        return view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
