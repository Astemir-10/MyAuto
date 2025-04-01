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
import Skeleton

final class WidgetErrorView: UIView {
    private lazy var frontStackView = UIStackView().forAutoLayout()
    private lazy var errorImageView = UIImageView().forAutoLayout()
    private lazy var errorLabel = UILabel()
    private lazy var refreshButton = Button()
    
    init(errorText: String, refreshAction: @escaping () -> ()) {
        super.init(frame: .zero)
        self.errorLabel.text = errorText
        self.refreshButton.addAction(.init(handler: { _ in
            refreshAction()
        }), for: .touchUpInside)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(frontStackView)
        frontStackView.addConstraintToSuperView([.centerX(0), .centerY(0)])
        frontStackView.addArrangedSubviews(errorImageView, errorLabel, refreshButton)
        frontStackView.spacing = 8
        frontStackView.axis = .vertical
        frontStackView.alignment = .center
        frontStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).activated()
        errorImageView.image = .appImages.sfIcons.error.withSize(size: 48, weight: .bold)
        errorImageView.tintColor = UIColor.red
        errorImageView.setSize(width: 48, height: 48)
        frontStackView.addConstraintToSuperView([.top(8), .bottom(-8)])
        refreshButton.primaryText = "Обновить"
        
        errorLabel.font = .appFonts.secondaryLarge
        errorLabel.textColor = .appColors.text.primary
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
    }

}


final class PetrolSkeletonView: UIView {
    private lazy var topLeftView = UIView().forAutoLayout()
    private lazy var topRightView = UIView().forAutoLayout()
    private lazy var topStackView = UIStackView().forAutoLayout()
    private lazy var bottomStackView = UIStackView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        topLeftView.setSize(width: 150, height: 24)
        topLeftView.showSkeletonAnimation()

        
        topRightView.setSize(width: 90, height: 24)
        topRightView.showSkeletonAnimation()
        
        self.addSubviews(contentStackView)
        contentStackView.addConstraintToSuperView([.top(0), .bottom(0), .trailing(0), .leading(0)])
        contentStackView.addArrangedSubview(topStackView)
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        topStackView.addArrangedSubviews(topLeftView, topRightView)
        contentStackView.addArrangedSubview(bottomStackView)
        contentStackView.spacing = 20
        contentStackView.axis = .vertical
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 12
        for _ in 0...2 {
            bottomStackView.addArrangedSubview(makeCardSkeleton())
        }
    }
    
    private func makeCardSkeleton() -> UIView {
        let view = UIView().forAutoLayout()
        view.setSize(height: 100)
        view.showSkeletonAnimation(cornerRadius: 15)
        return view
    }
}

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
    
    private lazy var rightHeaderItemsStackView = UIStackView()
    private lazy var leftHeaderItemsStackView = UIStackView()
    private lazy var skeletonView = PetrolSkeletonView().forAutoLayout()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        cardView.configure { config in
            config.edgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
            config.cornerRadius = 20
        }
        
        self.addSubview(cardView)
        
        cardView.addFourNullConstraintToSuperView()
        
        brandImageView.setSize(width: 28, height: 28)
        brandImageView.layer.cornerRadius = 8
        brandImageView.clipsToBounds = true
        contentView.addSubview(contentStackView)
        contentStackView.addFourNullConstraintToSuperView()
        contentStackView.addArrangedSubviews(headerStackView, pricesScrollView)
        
        leftHeaderItemsStackView.addArrangedSubviews(brandImageView, petrolNameLabel)
        headerStackView.axis = .horizontal
        headerStackView.spacing = 12
        headerStackView.distribution = .equalSpacing
        headerStackView.alignment = .leading
        headerStackView.addArrangedSubviews(leftHeaderItemsStackView, rightHeaderItemsStackView)
        
        leftHeaderItemsStackView.spacing = 12
        pricesScrollView.addSubview(pricesStackView)
        pricesScrollView.setSize(height: 104)
        pricesStackView.axis = .horizontal
        pricesStackView.distribution = .equalSpacing
        pricesStackView.spacing = 20
        pricesStackView.alignment = .fill
        pricesStackView.addFourNullConstraintToSuperView()
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
        self.cardView.removeAllContentSubviews()
        skeletonView.removeFromSuperview()
        cardView.addContentView(contentView)
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
        
        rightHeaderItemsStackView.addArrangedSubview(makeRightHeaderItem(distance: model.distance))
        
        pricesStackView.addArrangedSubviews(petrols.map({ makePriceView(name: $0.0, value: $0.1, fullPetrol: $0.2)}))
    }
    
    func makeRightHeaderItem(distance: Double) -> UIView {
        let stackView = UIStackView()
        let imageView = UIImageView().forAutoLayout()
        imageView.setSize(width: 20,
                          height: 20)
        let titleLabel = UILabel().forAutoLayout()
        titleLabel.text = distance.format(.distance)
        titleLabel.textColor = .appColors.text.primary
        titleLabel.font = .appFonts.secondaryMedium
        stackView.addArrangedSubviews(imageView, titleLabel)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        imageView.tintColor = .appColors.text.blue
        imageView.contentMode = .scaleAspectFit
        imageView.image = .appImages.sfIcons.location.icon
        return stackView
    }
    
    func setLoading() {
        self.cardView.removeAllContentSubviews()
        self.cardView.addContentView(skeletonView)
    }
    
    func setError(refreshAction: @escaping () -> ()) {
        let errorView = WidgetErrorView(errorText: "Не смогли загрузить данные об АЗС", refreshAction: {
            refreshAction()
        }).forAutoLayout()
        self.cardView.removeAllContentSubviews()
        self.cardView.addContentView(errorView)
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
            contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            let view = PetrolView()
            view.setError { [weak self] in
                self?.output.refresh()
            }
            contentStackView.addArrangedSubview(view)

        case .loading:
            contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            let view = PetrolView()
            view.setLoading()
            contentStackView.addArrangedSubview(view)
        case .loaded(let data):
            contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
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
