//
//  WeatherWidgetView.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import UIKit
import DesignKit
import AppServices

final class WeatherWidgetView: UIViewController {
    
    var output: WeatherWidgetViewOutput!
    
    private lazy var cardView = CardView().forAutoLayout()
    
    private lazy var temperatureMinLabel: UILabel = {
        let lbl = UILabel().forAutoLayout()
        return lbl
    }()
    
    private lazy var temperatureMaxLabel: UILabel = {
        let lbl = UILabel().forAutoLayout()
        return lbl
    }()
    
    private lazy var precipitationSumLabel: UILabel = {
        let lbl = UILabel().forAutoLayout()
        return lbl
    }()
    
    private lazy var weathercodeLabel: UILabel = {
        let lbl = UILabel().forAutoLayout()
        return lbl
    }()
    
    private lazy var snowfallSumLabel: UILabel = {
        let lbl = UILabel().forAutoLayout()
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        view.addSubview(cardView)
        cardView.addConstraintToSuperView([.bottom(0), .leading(0), .top(0), .trailing(0)])
        cardView.addContentView(temperatureMinLabel)
        cardView.addContentView(temperatureMaxLabel, spacing: 12)
        
        cardView.addContentView(precipitationSumLabel, spacing: 12)
        cardView.addContentView(weathercodeLabel, spacing: 12)
        cardView.addContentView(snowfallSumLabel, spacing: 12)
    }
    
}

extension WeatherWidgetView: WeatherWidgetViewInput {
    func setState(_ state: WidgetState) {
        switch state {
        case .error:
            break
        case .loading:
            break
        case .loaded(let data):
            if let item = data as? WeatherData, let forecast = item.days.first {
                temperatureMinLabel.text = String(Int(forecast.tempMin))
                temperatureMaxLabel.text = String(Int(forecast.tempMax.rounded()))
                
                precipitationSumLabel.text = String(Int(forecast.precipitationSum.rounded()))
                weathercodeLabel.text = String(forecast.weatherCode.rawValue)
                snowfallSumLabel.text = String(forecast.snowfallSum)
                
            }
        }
    }
}
