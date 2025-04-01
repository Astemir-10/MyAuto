//
//  SnowWithRainEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class SnowWithRainEvent: WeatherEventItem {
    
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        return emitterLayer
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        let snowCell = CAEmitterCell()
        let rainCell = CAEmitterCell()
        
        snowCell.contents = UIImage(named: "snowflake", in: .module, with: nil)?.cgImage
        snowCell.birthRate = 10
        snowCell.velocity = 30
        snowCell.lifetime = Float(UIScreen.main.bounds.height / snowCell.velocity)
        snowCell.velocityRange = 10
        snowCell.emissionLongitude = .pi
        snowCell.scale = 0.1
        snowCell.scaleRange = 0.1
        
        rainCell.contents = CGImage.drawRainDrop()
        rainCell.birthRate = 25
        rainCell.velocity = 500
        rainCell.lifetime = Float(UIScreen.main.bounds.height / rainCell.velocity)
        rainCell.velocityRange = 150
        rainCell.emissionLongitude = .pi
        rainCell.scale = 0.1
        rainCell.scaleRange = 0.1
        
        return [snowCell, rainCell]
    }

    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.snowWithRain.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.steelBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
}
