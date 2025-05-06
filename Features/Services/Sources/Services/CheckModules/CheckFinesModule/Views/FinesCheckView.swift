//
//  File.swift
//  Services
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import UIKit
import DesignKit
import AppServices
import AnyFormatter

final class FinesCheckView: UIView, CheckViewInput, UITextFieldDelegate {
    
    weak var delegate: CheckViewOutput?
    
    private lazy var carPlateView: CarPlateView = CarPlateView().forAutoLayout()
    private lazy var stsTextField: TextField = TextField().forAutoLayout()
    private lazy var topView = UIView().forAutoLayout()
    private lazy var bottomStackView = UIStackView().forAutoLayout()
    private lazy var activateButton = Button().forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func setupUI() {
        addSubviews(topView, bottomStackView)
        topView.addConstraintToSuperView([.top(12), .leading(12), .trailing(-12)])
        bottomStackView.addConstraintToSuperView([.bottom(-20), .leading(0), .trailing(0)])
        topView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -20).activated()
        
        topView.addSubviews(carPlateView, stsTextField, activateButton)
        carPlateView.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8)])
        stsTextField.returnKeyType = .done
        stsTextField.addConstraintToSuperView([.leading(8), .trailing(-8)])
        stsTextField.setSize(height: 40)
        stsTextField.placeholder = "СТС"
        stsTextField.configure { config in
            config.cornerRadius = 10
        }
        stsTextField.topAnchor.constraint(equalTo: carPlateView.bottomAnchor, constant: 8).activated()
        stsTextField.backgroundColor = .appColors.ui.primaryAlternative
        activateButton.addConstraintToSuperView([.leading(8), .trailing(-8), .bottom(-8)])
        activateButton.topAnchor.constraint(equalTo: stsTextField.bottomAnchor, constant: 20).activated()
        
        activateButton.setSize(.medium)
        activateButton.setBackgroundStyle(.primary)
        activateButton.primaryText = "Найти"
        self.carPlateView.didTapReturn { [weak self] in
            self?.endEditing(true)
        }
        
        stsTextField.delegate = self

        activateButton.addAction(.init(handler: { [weak self] _ in
            var texts = [String: String]()
            if let sts = self?.stsTextField.text  {
                texts["sts"] = sts
            }
            
            if let plate = self?.carPlateView.number {
                texts["plate"] = plate
            }
            self?.endEditing(true)
            self?.delegate?.didTapStart(data: texts)
        }), for: .touchUpInside)
        
        bottomStackView.spacing = 8
        bottomStackView.axis = .vertical
        backgroundColor = .appColors.ui.main
    }
    
    func setModel(model: Any) {
        if let model = model as? FineResponse {
            bottomStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            
            model.data.forEach({
                let view = makeItemView(data: $0).forAutoLayout()
                bottomStackView.addArrangedSubview(view)
                view.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor).activated()
            })
            var sum: Double = 0
            model.data.forEach({ sum += Double($0.summa) })
            bottomStackView.addArrangedSubview(makeSumView(sum: sum.format(.currency)))
        }
    }
    
    private func makeItemView(data: FineData) -> UIView {
        let view = UIView().forAutoLayout()
        let label = UILabel().forAutoLayout()
        label.text = Double(data.summa).format(.currency)
        view.addSubview(label)
        label.addFourNullConstraintToSuperView(constant: 12)
        
        view.layer.cornerRadius = 5
        view.backgroundColor = .appColors.ui.primaryAlternative
        
        return view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    func makeSumView(sum: String) -> UIView {
        let view = UIView().forAutoLayout()
        let sumLabel = UILabel().forAutoLayout()
        view.addSubview(sumLabel)
        sumLabel.text = sum
        sumLabel.font = .appFonts.textMedium
        sumLabel.addConstraintToSuperView([.bottom(0), .leading(20), .trailing(-20), .top(40)])
        return view
    }
                      
}


