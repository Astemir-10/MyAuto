//
//  WeatherEffectConfigurable.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

typealias WeatherEventItem = WeatherEffectConfigurable & WeatherEventConfigurable

public protocol WeatherEffectConfigurable {
    
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer?
    func configureEmitterCells() -> [CAEmitterCell]?
    
    func configureAdditionalSublayers(on bounds: CGRect) -> [CALayer]?
    func configureBackgroundColor() -> CGColor?
}

extension WeatherEffectConfigurable {
    
    func configureAdditionalSublayers(on bounds: CGRect) -> [CALayer]? {
        return nil
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor.white.cgColor
    }
}

protocol WeatherEventConfigurable {
    
    func fetchEventIcon() -> UIImage
}
