//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import UIKit
import DesignKit

struct MainCarInfoModel {
    let brand: String
    let model: String
    let year: Int
    let licensePlate: String
    let mileage: Double
    let fuelType: String
    let lastMaintenanceDate: String
    let maintenanceStatus: MaintenanceStatus
    let enginePower: Double
    let engineVolume: Double
    let carColor: String
    let fuelTankCapacity: Double
    let configuration: String
    let image: UIImage?
    let logo: UIImage?
    let fuelEconomy: Double
    let maxSpeed: Double
    let accelerationTime: Double
}

enum MaintenanceStatus {
    case good, warning, urgent
    
    var color: UIColor {
        switch self {
        case .good:
            return UIColor(named: "successColor") ?? UIColor.green
        case .warning:
            return UIColor(named: "warningColor") ?? UIColor.yellow
        case .urgent:
            return UIColor(named: "errorColor") ?? UIColor.red
        }
    }
    
    var text: String {
        switch self {
        case .good:
            return "ТО пройдено: ✅"
        case .warning:
            return "Скоро ТО ⚠"
        case .urgent:
            return "Срочно ТО ❗"
        }
    }
}

class MainCarInfoViewController: UIViewController {
    var output: MainCarInfoViewOutput!

    private lazy var carLogoView = {
        let imageView = UIImageView().forAutoLayout()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var carImageView = {
        let imageView = UIImageView().forAutoLayout()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDetailsCarInfo)))
        return imageView
    }()
    
    private lazy var carNameLabel = {
        let lbl = UILabel().forAutoLayout()
        lbl.font = .appFonts.textSemibold
        lbl.textColor = .appColors.text.primary
        return lbl
    }()
    
    private lazy var carConfigurationLabel = {
        let lbl = UILabel().forAutoLayout()
        lbl.font = .appFonts.secondaryButton
        lbl.textColor = .appColors.text.primary

        return lbl
    }()
    
    private lazy var cardsStackView = UIStackView()
    
    private lazy var topStackView = UIStackView().forAutoLayout()
    private lazy var firstCarInfoStack = UIStackView().forAutoLayout()
    private lazy var secondCarInfoStack = UIStackView().forAutoLayout()
    private lazy var thirdCarInfoStack = UIStackView().forAutoLayout()
    
    private lazy var mainStackView = UIStackView().forAutoLayout()

    private lazy var MainCarInfoLabel = UILabel()
    private lazy var licensePlateLabel = UILabel()
    private lazy var mileageLabel = UILabel()
    private lazy var fuelTypeLabel = UILabel()
    private lazy var maintenanceStatusLabel = UILabel()
    private lazy var enginePowerLabel = UILabel()
    private lazy var engineVolumeLabel = UILabel()
    private lazy var carColorLabel = UILabel()
    private lazy var fuelTankCapacityLabel = UILabel()
    private lazy var configurationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        carImageView.contentMode = .scaleAspectFit
        carImageView.clipsToBounds = true
        carImageView.layer.cornerRadius = 8
                
        view.addSubview(mainStackView)
        view.addSubview(carImageView)
        view.addSubview(carLogoView)
        
        carImageView.addConstraintToSuperView([.leading(8), .trailing(-8), .top(8)])
        mainStackView.addConstraintToSuperView([.leading(16), .trailing(-16), .bottom(-8)])
        
        carLogoView.setSize(width: 32, height: 32)
        carLogoView.addConstraintToSuperView([.top(0), .leading(16)])
                
        topStackView.addArrangedSubviews(carNameLabel, carConfigurationLabel)
        topStackView.axis = .vertical
        topStackView.spacing = 8
        topStackView.addConstraintToSuperView([.leading(0), .trailing(0)])
        
        let carConfigurationsStackView = UIStackView()
        
        carConfigurationsStackView.addArrangedSubviews(firstCarInfoStack, secondCarInfoStack, thirdCarInfoStack)
        carConfigurationsStackView.axis = .horizontal
        carConfigurationsStackView.distribution = .fill
        carConfigurationsStackView.spacing = 8
        
        firstCarInfoStack.axis = .vertical
        secondCarInfoStack.axis = .vertical
        thirdCarInfoStack.axis = .vertical
        
        secondCarInfoStack.distribution = .fill
        secondCarInfoStack.spacing = 12
        
        firstCarInfoStack.distribution = .fill
        firstCarInfoStack.spacing = 12
        
        thirdCarInfoStack.distribution = .fill
        thirdCarInfoStack.spacing = 12
        
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(carConfigurationsStackView)
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.addArrangedSubview(cardsStackView)
        cardsStackView.alignment = .fill
        cardsStackView.spacing = 16
        cardsStackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            carImageView.heightAnchor.constraint(equalToConstant: 200),
            
            mainStackView.topAnchor.constraint(equalTo: carImageView.bottomAnchor, constant: 20),
            
        ])
    }
    
    @objc private func openDetailsCarInfo() {
        output.openDetailsCarInfo()
    }
    
    private func makeLabel(image: UIImage, title: String, subtitle: String) -> UIView {
        let stackView = UIStackView()
        let stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView.alignment = .leading
        stackView2.spacing = 4
        
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        let imageView = UIImageView().forAutoLayout()
        imageView.setSize(width: 16, height: 16)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .appFonts.secondaryNeutral
        titleLabel.textColor = .appColors.text.primary
        
        subtitleLabel.font = .appFonts.neutralSemibold
        subtitleLabel.textColor = .appColors.text.primary
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        stackView2.addArrangedSubviews(titleLabel, imageView)
        stackView.addArrangedSubviews(stackView2, subtitleLabel)
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }
    
    private func makeCardLabel(title: String, subtitle: String) -> UIView {
        let cardView = CardView().forAutoLayout()
        let titleLabel = UILabel()
        titleLabel.text = title
        cardView.addContentView(titleLabel)
        titleLabel.font = .appFonts.neutralSemibold
        titleLabel.textColor = .appColors.text.primary

        let subtitleLabel = UILabel()
        cardView.addContentView(subtitleLabel)
        subtitleLabel.font = .appFonts.descriptionSmall
        subtitleLabel.textColor = .appColors.text.primary
        subtitleLabel.text = subtitle
        
        return cardView
    }
}

extension MainCarInfoViewController: MainCarInfoViewInput {
    func updateMainCarInfo(with model: MainCarInfoModel) {
        let firstLabel = makeLabel(image: .appImages.sfIcons.enginePower.icon, title: "Мощность", subtitle: model.enginePower.format(.horsepower))
        let secondLabel = makeLabel(image: .appImages.sfIcons.maxSpeedometr.icon, title: "Макс. скорость", subtitle: model.maxSpeed.format(.speed))
        let thirdLabel = makeLabel(image: .appImages.sfIcons.stopwatch.icon, title: "От 0 до 100", subtitle: model.accelerationTime.format(.time))
        
        
        
        let firstSecondLabel = makeLabel(image: .appImages.sfIcons.distance.icon, title: "Пробег", subtitle: model.mileage.format(.distance))
        let secondSecondLabel = makeLabel(image: .appImages.sfIcons.engineVolume.icon, title: "Объем двигателя", subtitle: model.engineVolume.format(.liters))
        let thirdSecondLabel = makeLabel(image: .appImages.sfIcons.fuelpump.icon, title: "Тип топлива", subtitle: "\(model.fuelType)")
        
        thirdCarInfoStack.addArrangedSubviews(firstLabel, thirdSecondLabel)
        secondCarInfoStack.addArrangedSubviews(thirdLabel, firstSecondLabel)
        firstCarInfoStack.addArrangedSubviews(secondSecondLabel, secondLabel)
        
        carNameLabel.text = "\(model.brand) \(model.model), \(model.year)"
        carConfigurationLabel.text = model.configuration
        carLogoView.image = model.logo
        carImageView.image = model.image
        
        let firstCard = makeCardLabel(title: "Последнее ТО", subtitle: "135 000 км")
        let secondCard = makeCardLabel(title: "Следующее ТО", subtitle: "145 000 км")
        cardsStackView.addArrangedSubviews(firstCard, secondCard)
    }
}
