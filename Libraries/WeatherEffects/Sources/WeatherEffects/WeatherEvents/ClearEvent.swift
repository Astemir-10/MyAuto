//
//  ClearEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class ClearEvent: WeatherEventItem {
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        return nil
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        return nil
    }
    
    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.clear.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.lightBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
    
    func configureAdditionalSublayers(on bounds: CGRect) -> [CALayer]? {
        let sunLayer = CALayer()
        
        sunLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        sunLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        sunLayer.contentsGravity = .resizeAspectFill
        sunLayer.cornerRadius = 50
        
        addGlowEffect(to: sunLayer, color: UIColor.yellow.cgColor)
        
        return [sunLayer]
    }
    
    private func addGlowEffect(to layer: CALayer, color: CGColor) {
        let glowLayer = CALayer()
        glowLayer.frame = layer.bounds
        glowLayer.backgroundColor = color
        glowLayer.cornerRadius = layer.bounds.width / 2
        glowLayer.shadowColor = color
        glowLayer.shadowRadius = 20
        glowLayer.shadowOpacity = 1.0
        glowLayer.shadowOffset = CGSize.zero
        
        layer.insertSublayer(glowLayer, at: 0)
    }
}
