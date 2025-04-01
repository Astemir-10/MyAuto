//
//  HeavyRainEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class HeavyRainEvent: WeatherEventItem {
    
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        return emitterLayer
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        let heavyRainCell = CAEmitterCell()
        
        heavyRainCell.contents = CGImage.drawRainDrop()
        heavyRainCell.birthRate = 150
        heavyRainCell.velocity = 700
        heavyRainCell.lifetime =  Float(UIScreen.main.bounds.height / heavyRainCell.velocity)
        heavyRainCell.velocityRange = 150
        heavyRainCell.emissionLongitude = .pi
        heavyRainCell.scale = 0.1
        heavyRainCell.scaleRange = 0.1
        
        return [heavyRainCell]
    }
    
    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.heavyRain.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.steelBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
}
