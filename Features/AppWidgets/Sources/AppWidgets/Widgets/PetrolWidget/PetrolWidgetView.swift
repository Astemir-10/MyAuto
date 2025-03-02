//
//  File.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 03.11.2024.
//

import UIKit
import DesignKit
import AppMap
import AnyFormatter

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
    
    private lazy var pricesStackView = UIStackView()
    private lazy var headerStackView = UIStackView()
    
    private lazy var contentView = UIView().forAutoLayout()
    private lazy var pricesScrollView = UIScrollView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.addSubview(cardView)
        
        cardView.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)])
        cardView.configure { config in
            config.edgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
            config.cornerRadius = 20
        }
        
        headerStackView.addArrangedSubviews([brandImageView, petrolNameLabel])
        brandImageView.setSize(width: 24, height: 24)
        brandImageView.layer.cornerRadius = 8
        brandImageView.clipsToBounds = true
        cardView.addContentView(contentView)
        contentView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0), .bottom(0)])
        contentStackView.addArrangedSubviews(headerStackView, pricesScrollView)

        
        headerStackView.axis = .horizontal
        headerStackView.spacing = 12
        headerStackView.distribution = .fill
        headerStackView.alignment = .leading
        
        pricesScrollView.addSubview(pricesStackView)
        pricesScrollView.setSize(height: 104)
        pricesStackView.axis = .horizontal
        pricesStackView.distribution = .equalSpacing
        pricesStackView.spacing = 20
        pricesStackView.alignment = .fill
        pricesStackView.addConstraintToSuperView([.top(0), .leading(0), .bottom(0), .trailing(0)])
        pricesScrollView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).activated()
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.alignment = .fill
        contentStackView.distribution = .equalSpacing
        pricesScrollView.showsHorizontalScrollIndicator = false
        pricesScrollView.showsHorizontalScrollIndicator = false
    }

    private func makePriceView(name: String, value: String, fullPetrol: String) -> UIView {
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .appFonts.secondaryNeutral
        nameLabel.textColor = .appColors.text.primary
        nameLabel.textAlignment = .center
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textAlignment = .center
        valueLabel.textColor = .appColors.text.primary
        valueLabel.font = .appFonts.neutralSemibold

        
        let cardView = CardView()
        
        cardView.configure { config in
            config.level = 2
            config.edgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            config.cornerRadius = 8
        }
        
        let priceStackView = UIStackView()
        priceStackView.alignment = .center
        priceStackView.spacing = 8
        priceStackView.axis = .vertical
        
        let contentStackView = UIStackView()
        contentStackView.alignment = .center
        contentStackView.spacing = 0
        contentStackView.axis = .vertical
        
        priceStackView.addArrangedSubviews(nameLabel, valueLabel)
        priceStackView.axis = .vertical
        
        let fullPetrolCardView = CardView()
        fullPetrolCardView.configure { config in
            config.edgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            config.spacing = 0
            config.cornerRadius = 4
            config.level = 3
        }
        let fullPetrolPriceLabel = UILabel()
        fullPetrolPriceLabel.text = fullPetrol
        fullPetrolPriceLabel.textColor = .appColors.text.primary
        fullPetrolPriceLabel.font = .appFonts.smallNeutral
        fullPetrolCardView.addContentView(fullPetrolPriceLabel)
        
        contentStackView.addArrangedSubviews(priceStackView, fullPetrolCardView)
        contentStackView.spacing = 12
                
        cardView.addContentView(contentStackView)
       
        return cardView
    }
    
    func setModel(_ model: PetrolWidgetInfoModel) {
        pricesStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        self.petrolNameLabel.text = model.name
        self.brandImageView.image = model.image
        
        
        var petrols: [(String, String, String)] = []
        
        if let ai92 = model.ai92 {
            let fullPetrol = ai92 * 70
            petrols.append(("АИ-92",
                            ai92.format(.fuelPrice),
                            fullPetrol.format(.currency)))
        }
        
        if let ai95 = model.ai95 {
            let fullPetrol = ai95 * 70
            petrols.append(("АИ-95",
                            ai95.format(.fuelPrice),
                            fullPetrol.format(.currency)))
        }
        
        if let ai100 = model.ai100 {
            let fullPetrol = ai100 * 70
            petrols.append(("АИ-100",
                            ai100.format(.fuelPrice),
                            fullPetrol.format(.currency)))
        }
        
        if let gas = model.gas {
            let fullPetrol = gas * 70
            petrols.append(("ГАЗ",
                            gas.format(.fuelPrice),
                            fullPetrol.format(.currency)))
        }
        
        if let dt = model.dt {
            let fullPetrol = dt * 70
            petrols.append(("ДТ",
                            dt.format(.fuelPrice),
                            fullPetrol.format(.currency)))
        }
        
        pricesStackView.addArrangedSubviews(petrols.map({ makePriceView(name: $0.0, value: $0.1, fullPetrol: $0.2)}))
    }
}

final class PetrolWidgetView: UIViewController {
    
    var output: PetrolWidgetViewOutput!
    
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        view.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.addConstraintToSuperView([.bottom(-16), .leading(16), .trailing(-16), .top(0)])
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
                data.petrols.forEach({ item in
                    let view = PetrolView()
                    view.setModel(item)
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
                    view.addGestureRecognizer(gesture)
                    gesture.delegate = self
                   
                    contentStackView.addArrangedSubview(view)
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
