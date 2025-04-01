//
//  WeatherEffectLayer.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

public final class WeatherEffectLayer: CALayer {
    
    // MARK: - Instance Properties
    
    private var contentSublayer: CALayer?
    private var currentEvent: WeatherEvents?
    
    // MARK: - Setup
    
    public func setupStyle(with color: CGColor? = nil) {
        backgroundColor = color
    }
    
    // MARK: - Instance Methods
    
    public func configure(with effectType: WeatherEvents, needAddingSublayer: Bool = false) {
        self.currentEvent = effectType
        let effect: WeatherEventItem
        switch effectType {
        case .clear: effect = ClearEvent()
        case .rain: effect = RainEvent()
        case .heavyRain: effect = HeavyRainEvent()
        case .cloudy: effect = CloudyEvent()
        case .storm: effect = StormEvent()
        case .snow: effect = SnowEvent()
        case .snowWithRain: effect = SnowWithRainEvent()
        case .blizzard: effect = BlizzardEvent()
        case .fog: effect = FogEvent()
        case .windy: effect = WindyEvent()
        }
        
        if let backgroundColor = effect.configureBackgroundColor() {
            setupStyle(with: backgroundColor)
        }
        
        if !needAddingSublayer {
            return
        }
        
        removeOldSublayer()
        
        let newContentSublayer = CALayer()
        newContentSublayer.frame = bounds
        newContentSublayer.masksToBounds = true
        addSublayer(newContentSublayer)
        contentSublayer = newContentSublayer
        
        if let additionalSublayers = effect.configureAdditionalSublayers(on: bounds) {
            additionalSublayers.forEach { newContentSublayer.addSublayer($0) }
        }
        
        if let newEmitterLayer = effect.configureEmitterLayer(with: bounds) {
            newEmitterLayer.frame = bounds
            newEmitterLayer.masksToBounds = true
            newEmitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.minY)
            newEmitterLayer.emitterSize = CGSize(width: bounds.width, height: 1)
            newEmitterLayer.emitterShape = .line
            newEmitterLayer.emitterCells = effect.configureEmitterCells()
            newContentSublayer.addSublayer(newEmitterLayer)
        }
    }
    
    private func removeOldSublayer() {
        guard let oldContentSublayer = contentSublayer else { return }
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = 0.8
        fadeOutAnimation.isRemovedOnCompletion = false
        fadeOutAnimation.fillMode = .forwards
        
        oldContentSublayer.add(fadeOutAnimation, forKey: "fadeOut")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutAnimation.duration) {
            oldContentSublayer.removeFromSuperlayer()
        }
    }
    
    // MARK: - Layout Fix
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        contentSublayer?.frame = bounds
        
        if let currentEvent, contentSublayer == nil {
            self.configure(with: currentEvent, needAddingSublayer: true)
        }
    }
}
