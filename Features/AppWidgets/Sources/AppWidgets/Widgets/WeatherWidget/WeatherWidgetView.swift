//
//  WeatherWidgetView.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import UIKit
import DesignKit
import AppServices
import WeatherEffects
import Extensions
import Skeleton

final class WeatherSkeletonView: UIView {
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
        contentStackView.addFourNullConstraintToSuperView()
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

final class WeatherView: UIView {
    private lazy var cardView = CardView().forAutoLayout()
    private lazy var advicebackgroundView = UIView()
    private lazy var adviceView = UIView().forAutoLayout()
    private lazy var adviceLabel = UILabel().forAutoLayout()

    private lazy var temperatureLabel = UILabel().forAutoLayout()
    private lazy var weatherIconView = UIImageView().forAutoLayout()
    private lazy var skeletonView = WeatherSkeletonView().forAutoLayout()
    private lazy var topStackView = UIStackView()
    private lazy var hourlyScrollView = UIScrollView().forAutoLayout()
    private lazy var hourlyContentStackView = UIStackView().forAutoLayout()
    private var needSetScrollPosition = false
    private var selectedHourlyIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.addSubviews(cardView)
        cardView.addContentView(contentStackView)
        cardView.addFourNullConstraintToSuperView()
        
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .fill
        let tempView = makeBlurWith(contentView: temperatureLabel).forAutoLayout()
        tempView.setSize(width: 100, height: 78)
        weatherIconView.setSize(width: 48, height: 48)
        weatherIconView.contentMode = .scaleAspectFit
        topStackView.addArrangedSubviews([tempView, weatherIconView])
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        topStackView.alignment = .top
        weatherIconView.image = .appImages.sfIcons.home.icon
        
        
        temperatureLabel.textColor = .appColors.text.primary
        
        temperatureLabel.font = .appFonts.largeBold
        temperatureLabel.textAlignment = .center
        advicebackgroundView.addSubview(adviceView)
        adviceView.addSubview(adviceLabel)
        
        adviceView.addConstraintToSuperView([.top(0), .bottom(0), .centerX(0)])
        adviceView.backgroundColor = .appColors.ui.primaryAlternativeSecondary
        
        adviceLabel.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8), .bottom(-8)])
        adviceLabel.numberOfLines = 0
        adviceLabel.font = .appFonts.secondaryMedium
        adviceLabel.textColor = .appColors.text.primary
        adviceLabel.textAlignment = .center
        
        contentStackView.spacing = 20
        adviceView.layer.cornerRadius = 10
        hourlyScrollView.addSubview(hourlyContentStackView)
        hourlyScrollView.setSize(height: 90)
        hourlyContentStackView.addConstraintToSuperView([.leading(0), .trailing(0), .centerY(0)])
        
        hourlyContentStackView.axis = .horizontal
        hourlyContentStackView.spacing = 8
        hourlyContentStackView.distribution = .fillEqually
        
        hourlyScrollView.showsHorizontalScrollIndicator = false
    }
    
    func setModel(model: WeatherWidgetModel) {
        configureWeatherState(code: model.code, isWind: model.windSpeed > 20)
        temperatureLabel.text = model.temperature.format(.temperature)
        self.selectedHourlyIndex = model.currentHourIndex
        adviceLabel.text = model.code.description
        hourlyContentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        model.hourly.enumerated().forEach({
            hourlyContentStackView.addArrangedSubview(makeHourlyView($0.element, isCurrent: model.currentHourIndex == $0.offset))
        })
        
        contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        contentStackView.addArrangedSubviews(topStackView, hourlyScrollView, advicebackgroundView)
        advicebackgroundView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).activated()
        adviceView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: 0).activated()
        hourlyScrollView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).activated()
        needSetScrollPosition = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let selectedHourlyIndex, let width = hourlyContentStackView.arrangedSubviews.first?.frame.width, needSetScrollPosition, width > 0 {
            let x = width * CGFloat((selectedHourlyIndex + 1))
            hourlyScrollView.setContentOffset(.init(x: x, y: 0), animated: false)
            needSetScrollPosition = false
        }
    }
    
    private func makeBlurWith(contentView: UIView) -> UIView {
        let blurView = UIView()
        blurView.backgroundColor = .appColors.ui.primaryAlternativeSecondary
        contentView.translatesAutoresizingMaskIntoConstraints = false
        blurView.addSubview(contentView)
        
        contentView.addConstraintToSuperView([.top(12), .leading(12), .trailing(-12), .bottom(-12)])
        blurView.layer.cornerRadius = 10
        blurView.clipsToBounds = true
        return blurView
    }
    
    private func configureWeatherState(code: WeatherCode, isWind: Bool) {
        self.weatherIconView.image = code.icon
    }
    
    private func makeHourlyView(_ item: HourlyWeather, isCurrent: Bool) -> UIView {
        var time = item.date.toString(dateForamtter: .timeFormatter)
        
        if time.first == "0" && time[time.index(time.startIndex, offsetBy: 1)] != "0" {
            time.removeFirst()
        }
        let view = UIView().forAutoLayout()
        let timeLabel = UILabel()
        let codeImageView = UIImageView().forAutoLayout()
        let tempLabel = UILabel().forAutoLayout()
        view.addSubviews([codeImageView, tempLabel, timeLabel])
        codeImageView.setSize(width: 24, height: 24)
        codeImageView.addConstraintToSuperView([.top(8), .centerX(0)])
        tempLabel.topAnchor.constraint(equalTo: codeImageView.bottomAnchor, constant: 6).activated()
        tempLabel.addConstraintToSuperView([.leading(8), .trailing(-8)])
        tempLabel.textAlignment = .center
        timeLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 6).activated()
        timeLabel.addConstraintToSuperView([.bottom(-8), .leading(8), .trailing(-8)])
        timeLabel.textAlignment = .center
        
        timeLabel.font = .appFonts.secondaryNeutral
        timeLabel.textColor = .appColors.text.primary
        timeLabel.text = time
        
        tempLabel.font = .appFonts.secondaryMedium
        tempLabel.textColor = .appColors.text.primary
        tempLabel.text = item.temperature2m.format(.temperature)
        
        codeImageView.contentMode = .scaleAspectFit
        codeImageView.image = item.weatherCode.icon
        
        if isCurrent {
            view.layer.cornerRadius = 5
            view.backgroundColor = .appColors.ui.primaryAlternativeThirdty
        }
        
        return view
    }
    
    func setError(refreshAction: @escaping () -> Void) {
        let errorView = WidgetErrorView(errorText: "Не удалось загрузить данные о погоде") {
            refreshAction()
        }
        contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        contentStackView.addArrangedSubview(errorView)
    }
    
    func setLoading() {
        contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        contentStackView.addArrangedSubview(skeletonView)
    }
}

final class WeatherWidgetView: UIViewController {
    
    var output: WeatherWidgetViewOutput!
    
    private lazy var headerView = HeaderView().forAutoLayout()

    private lazy var weatherView = WeatherView()
    private lazy var cityNameView = UIView().forAutoLayout()
    private lazy var locationIcon = UIImageView().forAutoLayout()
    private lazy var locationNameLabel = UILabel().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        view.addSubview(headerView)
        headerView.addConstraintToSuperView([.leading(0), .top(0), .trailing(0)])
        view.addSubview(weatherView)
        weatherView.addConstraintToSuperView([.bottom(0), .leading(16), .trailing(-16)])
        headerView.bottomAnchor.constraint(equalTo: weatherView.topAnchor).activated()
        
        cityNameView.addSubviews(locationIcon, locationNameLabel)
        locationIcon.addConstraintToSuperView([.leading(0), .top(0), .bottom(0)])
        locationNameLabel.addConstraintToSuperView([.trailing(0), .top(0), .bottom(0)])
        locationNameLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8).activated()
        locationNameLabel.font = .appFonts.descriptionSmall
        locationNameLabel.textColor = .appColors.text.primary
        locationIcon.setSize(width: 16, height: 16)
        locationIcon.image = .appImages.sfIcons.location2.icon
        locationIcon.tintColor = .appColors.text.blue
        
        headerView.set(title: "Погода", subtitle: Date().dateToString)
    }
}

extension WeatherWidgetView: WeatherWidgetViewInput {
    func setLocation(locationName: String) {
        cityNameView.removeFromSuperview()
        headerView.addRightView(view: cityNameView)
        locationNameLabel.text = locationName
    }
    
    func setState(_ state: WidgetState) {
        switch state {
        case .error:
            weatherView.setError { [weak self] in
                self?.output.refereshData()
            }
        case .loading:
            weatherView.setLoading()
        case .loaded(let data):
            
            if let item = data as? WeatherWidgetModel {
                weatherView.setModel(model: item)
            }
        }
    }
}



