//
//  CloudyEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class CloudyEvent: WeatherEventItem {
    
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterPosition = CGPoint(x: bounds.minX - bounds.midX, y: bounds.minY)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: bounds.size.height - bounds.size.height / 2)
        
        return emitterLayer
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        let cloudy1Cell = CAEmitterCell()
        let cloudy2Cell = CAEmitterCell()
        cloudy1Cell.contents = UIImage(named: "cloud1", in: .module, with: nil)?.cgImage
        
        cloudy1Cell.birthRate = 0.3
        cloudy1Cell.lifetime = 200.0
        cloudy1Cell.velocity = 10
        cloudy1Cell.velocityRange = 10
        cloudy1Cell.emissionRange = .pi / 2
        cloudy1Cell.scale = 0.1
        cloudy1Cell.scaleRange = 0.1
        cloudy1Cell.alphaSpeed = -0.02
        
        
        cloudy2Cell.contents = UIImage(named: "cloud2", in: .module, with: nil)?.cgImage
        cloudy2Cell.birthRate = 0.3
        cloudy2Cell.lifetime = 200.0
        cloudy2Cell.velocity = 10
        cloudy2Cell.velocityRange = 10
        cloudy2Cell.emissionRange = .pi / 2
        cloudy2Cell.scale = 0.1
        cloudy2Cell.scaleRange = 0.1
        cloudy2Cell.alphaSpeed = -0.02
        
        return [cloudy1Cell, cloudy2Cell]
    }

    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.cloudy.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.steelBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
}
