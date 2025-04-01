//
//  RainEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class RainEvent: WeatherEventItem {
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        return emitterLayer
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        let rainCell = CAEmitterCell()
        rainCell.contents = CGImage.drawRainDrop()
        rainCell.birthRate = 35
        rainCell.velocity = 500
        rainCell.lifetime =  Float(UIScreen.main.bounds.height / rainCell.velocity)
        rainCell.velocityRange = 150
        rainCell.emissionLongitude = .pi
        rainCell.scale = 0.1
        rainCell.scaleRange = 0.1
        
        return [rainCell]
    }

    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.rain.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.steelBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
}
