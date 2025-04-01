//
//  WindyEvent.swift
//  WeatherEffects
//
//  Created by Олег Романов on 22.07.2024.
//

import UIKit

final class WindyEvent: WeatherEventItem {
    
    func configureEmitterLayer(with bounds: CGRect) -> CAEmitterLayer? {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: bounds.minX, y: bounds.midY)
        emitterLayer.emitterSize = CGSize(width: 1, height: bounds.height)
        emitterLayer.renderMode = .additive
        return emitterLayer
    }
    
    func configureEmitterCells() -> [CAEmitterCell]? {
        let windyPointsCell = CAEmitterCell()
        let windyLinesCell = CAEmitterCell()
        
        // ⚡ Ветреные точки
        windyPointsCell.contents = CGImage.drawPoint()
        windyPointsCell.birthRate = 50
        windyPointsCell.lifetime = 4
        windyPointsCell.velocity = 300
        windyPointsCell.velocityRange = 100
        windyPointsCell.emissionLongitude = .pi
        windyPointsCell.emissionRange = 0.3
        windyPointsCell.scale = 0.05
        windyPointsCell.scaleRange = 0.03
        windyPointsCell.alphaSpeed = -0.2
        windyPointsCell.xAcceleration = -100 // Ветер дует слева направо
        
        // 🌬 Кривые линии ветра
        windyLinesCell.contents = CGImage.drawCurvedLine()
        windyLinesCell.birthRate = 10
        windyLinesCell.lifetime = 3
        windyLinesCell.velocity = 350
        windyLinesCell.velocityRange = 150
        windyLinesCell.emissionLongitude = -.pi // Движение слева направо
        windyLinesCell.scale = 0.1
        windyLinesCell.scaleRange = 0.05
        windyLinesCell.alphaSpeed = -0.4
        windyLinesCell.xAcceleration = 80 // Ускорение движения вправо
        windyLinesCell.yAcceleration = 20 // Колебания вверх-вниз
        windyLinesCell.spin = 2.0 // Вращение для эффекта волны
        windyLinesCell.spinRange = 3.0 // Случайное вращение линий
        
        return [windyPointsCell, windyLinesCell]
    }
    
    func fetchEventIcon() -> UIImage {
        return UIImage(systemName: WeatherEvents.windy.iconSystemName) ?? UIImage()
    }
    
    func configureBackgroundColor() -> CGColor? {
        return UIColor(named: ColorNameConstants.lightBlueColor, in: .module, compatibleWith: nil)?.cgColor
    }
}

extension CGImage {
    static func drawCurvedLine() -> CGImage? {
        let size = CGSize(width: 100, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: size.height / 2))
        path.addCurve(to: CGPoint(x: size.width, y: size.height / 2),
                      controlPoint1: CGPoint(x: size.width * 0.3, y: 0),
                      controlPoint2: CGPoint(x: size.width * 0.7, y: size.height))
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(2)
        context.addPath(path.cgPath)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        return image
    }
}
