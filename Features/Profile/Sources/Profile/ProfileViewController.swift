//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit
import CarInfo
import AnyFormatter

final class CarInfoView: UIView {
    
    private lazy var carName: UILabel = {
        let lbl = UILabel().forAutoLayout()
        lbl.textColor = .appColors.text.primary
        lbl.font = .appFonts.neutralMedium
        return lbl
    }()
    
    private lazy var carNumber: UILabel = {
        let lbl = UILabel().forAutoLayout()
        lbl.textColor = .appColors.text.primary
        lbl.font = .appFonts.neutralMedium
        return lbl
    }()
    
    private lazy var contentStackView: UIStackView = UIStackView().forAutoLayout()
    
    private lazy var cardView: CardView = CardView().forAutoLayout()
    
    private var carInfoDetailsModel: CarInfoDetailsModel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        addSubview(cardView)
        cardView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.top(16), .bottom(-16), .leading(16), .trailing(-16)])
        contentStackView.addArrangedSubviews([carName, carNumber])
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        cardView.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)])
    }
    
    private func updateUI() {
        if let carModel = carInfoDetailsModel {
            carName.text = carModel.carBrand
            carNumber.text = carModel.number?.carNumerFormatted ?? ""
        } else {
            carName.text = ""
            carNumber.text = ""
        }
    }
    
    func setCarModel(_ model: CarInfoDetailsModel) {
        self.carInfoDetailsModel = model
        updateUI()
    }
}

public final class ProfileViewController: CommonViewController {
    
    private lazy var addCarButton: Button = {
        let btn = Button().forAutoLayout()
        btn.primaryText = "Добавить"
        return btn
    }()
    
    private lazy var carInfoView = CarInfoView()
    
    var output: ProfileViewOutput!

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        view.addSubviews(carInfoView, addCarButton)
        
        carInfoView.addConstraintToSuperView([.top(20), .leading(20), .trailing(-20)], withSafeArea: true)
        addCarButton.addConstraintToSuperView([.centerX(0)])
        addCarButton.topAnchor.constraint(equalTo: carInfoView.bottomAnchor, constant: 30).activated()
        
        addCarButton.addAction(.init(handler: { [weak self] _ in
            self?.output.didTapAddButton()
        }), for: .touchUpInside)
    }
}

extension ProfileViewController: ProfileViewInput {
    func setData(carInfoDetailsModel: CarInfo.CarInfoDetailsModel) {
        
        self.carInfoView.setCarModel(carInfoDetailsModel)
    }
}

