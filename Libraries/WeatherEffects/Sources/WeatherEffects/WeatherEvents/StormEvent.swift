//
//  StormEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class StormEvent: WeatherEventItem {
    
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        return emitterLayer
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        let stormRainCell = CAEmitterCell()
        
        stormRainCell.contents = CGImage.drawRainDrop()
        stormRainCell.birthRate = 55
        stormRainCell.velocity = 550
        stormRainCell.lifetime =  Float(UIScreen.main.bounds.height / stormRainCell.velocity)
        stormRainCell.velocityRange = 150
        stormRainCell.emissionLongitude = .pi
        stormRainCell.scale = 0.1
        stormRainCell.scaleRange = 0.1
        
        return [stormRainCell]
    }

    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.storm.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.deepBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
    
    func configureAdditionalSublayers(on bounds: CGRect) -> [CALayer]? {
        let thunderLayer = CALayer()
        
        if let thunderImage = UIImage(named: "thunder", in: .module, with: nil)?.cgImage {
            thunderLayer.contents = thunderImage
            thunderLayer.contentsScale = 0.5
            thunderLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            thunderLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            thunderLayer.opacity = 1
        }
        
        let flashAnimation = CAKeyframeAnimation(keyPath: "opacity")
        flashAnimation.values = [0, 1, 0, 1, 0]
        flashAnimation.keyTimes = [0, 0.1, 0.2, 0.3, 0.4]
        flashAnimation.duration = 0.5
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 0
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.beginTime = 1.0
        fadeOutAnimation.duration = 3.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [flashAnimation, fadeOutAnimation]
        animationGroup.duration = 4
        animationGroup.repeatCount = .infinity
        animationGroup.timeOffset = 15.0
        
        thunderLayer.add(animationGroup, forKey: "lightningAnimation")
        
        return [thunderLayer]
    }
}
