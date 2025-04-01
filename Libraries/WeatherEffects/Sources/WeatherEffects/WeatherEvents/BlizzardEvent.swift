//
//  BlizzardEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class BlizzardEvent: WeatherEventItem {
    
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterPosition = CGPoint(x: bounds.maxX, y: bounds.midY)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: bounds.size.height)
        
        return emitterLayer
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        let snowCell = CAEmitterCell()
        
        snowCell.contents = UIImage(named: "snowflake", in: .module, with: nil)?.cgImage
        snowCell.birthRate = 250
        snowCell.velocity = 850
        snowCell.lifetime = 5
        snowCell.velocityRange = 200
        snowCell.emissionLongitude = .pi
        snowCell.emissionRange = 0.5
        snowCell.scale = 0.1
        snowCell.scaleRange = 0.1
        
        return [snowCell]
    }

    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.blizzard.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.deepBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
}
