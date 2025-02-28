//
//  File.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 03.11.2024.
//

import UIKit
import DesignKit
import AppMap

final class PetrolView: UIView {
    private lazy var cardView = CardView().forAutoLayout()
    
    private lazy var brandImageView: UIImageView = {
        let imageView = UIImageView().forAutoLayout()
        return imageView
    }()
    
    private lazy var petrolNameLabel: UILabel = {
        let label = UILabel()
        label.font = .appFonts.textMedium
        label.textColor = .appColors.text.primary
        return label
    }()
    
    private lazy var locationButton: Button = {
       let btn = Button()
        return btn.forAutoLayout()
    }()
    
    private lazy var pricesStackView = UIStackView()
    private lazy var headerStackView = UIStackView()
    
    private lazy var contentView = UIView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    var locationTapAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        cardView.isSecondLevel = true
        self.addSubview(cardView)
        locationButton.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
        
        cardView.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)])
        
        headerStackView.addArrangedSubviews([brandImageView, petrolNameLabel])
        brandImageView.setSize(width: 48, height: 48)
        brandImageView.layer.cornerRadius = 8
        brandImageView.clipsToBounds = true
        cardView.addContentView(contentView)
        self.contentView.addSubview(locationButton)
        contentView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0)])
        contentStackView.addArrangedSubviews(headerStackView, pricesStackView)
        contentStackView.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -20).activated()

        locationButton.addConstraintToSuperView([.leading(0), .bottom(0)])
        
        headerStackView.axis = .horizontal
        headerStackView.spacing = 20
        headerStackView.distribution = .fill
        headerStackView.alignment = .leading
        
        pricesStackView.axis = .horizontal
        pricesStackView.distribution = .equalSpacing
        pricesStackView.spacing = 20
        pricesStackView.alignment = .fill
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 32
        contentStackView.alignment = .fill
        contentStackView.distribution = .equalSpacing
        
        locationButton.configure({ configuration in
            configuration.cornerStyle = .rounded
            configuration.primaryFont = .appFonts.smallNeutral
            configuration.contentInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            configuration.backgroundColor = .appColors.ui.primaryButton.withAlphaComponent(0.2)
        })
    }

    @objc
    private func didTapLocation() {
        locationTapAction?()
    }
    
    private func makePriceView(name: String, value: String) -> UIView {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .appFonts.textMedium
        nameLabel.textColor = .appColors.text.primary
        nameLabel.textAlignment = .center
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textAlignment = .center
        valueLabel.textColor = .appColors.text.primary
        valueLabel.font = .appFonts.neutral
        let stackView = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
    
    func setModel(_ model: PetrolWidgetInfoModel) {
        pricesStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        self.petrolNameLabel.text = model.name
        self.brandImageView.image = model.image
        
        var locationButtonText: String?
        
        if let cityName = model.cityName, cityName != "" {
            locationButtonText = cityName
        } else if let raionName = model.regionName, raionName != "" {
            locationButtonText = raionName
        } else if let regionName = model.regionName, regionName != "" {
            locationButtonText = regionName
        }
        
        locationButton.primaryText = locationButtonText
        
        var petrols: [(String, String)] = []
        
        if let ai92 = model.ai92 {
            petrols.append(("АИ-92", String(ai92)))
        }
        
        if let ai95 = model.ai95 {
            petrols.append(("АИ-95", String(ai95)))
        }
        
        if let ai100 = model.ai100 {
            petrols.append(("АИ-100", String(ai100)))
        }
        
        if let gas = model.gas {
            petrols.append(("ГАЗ", String(gas)))
        }
        
        if let dt = model.dt {
            petrols.append(("ДТ", String(dt)))
        }
        
        pricesStackView.addArrangedSubviews(petrols.map({ makePriceView(name: $0.0, value: $0.1)}))
    }
}

final class PetrolWidgetView: UIViewController {
    
    var output: PetrolWidgetViewOutput!
    
    private lazy var cardView = CardView().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        view.addSubview(cardView)
        cardView.addConstraintToSuperView([.bottom(0), .leading(0), .trailing(0), .top(0)])
    }

}


extension PetrolWidgetView: PetrolWidgetViewInput, UIGestureRecognizerDelegate {
    func setState(_ state: WidgetState) {
        switch state {
        case .error:
            break
        case .loading:
            break
        case .loaded(let data):
            if let data = data as? PetrolWidgetModel {
                data.perrols.forEach({ item in
                    let view = PetrolView()
                    view.locationTapAction = { [weak self] in
                        self?.output.didTapLocation(item: item)
                    }
                    view.setModel(item)
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
                    view.addGestureRecognizer(gesture)
                    gesture.delegate = self
                   
                    cardView.addContentView(view, spacing: 20)
                })
            }
        }
    }
    
    @objc private func tapGesture() {
//        self.parent?.navigationController?.pushViewController(PetrolWidgetFull(), animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        (touch.view as? UIControl) == nil
    }
}
