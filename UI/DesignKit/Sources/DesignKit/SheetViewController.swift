//
//  SheetViewController.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit

final class SheetContentView: UIView {
    private lazy var graberView = GraberView().forAutoLayout()
    
    private lazy var contentView = UIView().forAutoLayout()
    
    override var backgroundColor: UIColor? {
        didSet {
            if self.backgroundColor != .clear {
                contentView.backgroundColor = backgroundColor
                self.backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.addSubview(graberView)
        self.addSubview(contentView)
        contentView.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)])
        graberView.addConstraintToSuperView([.top(0), .centerX(0)])
        graberView.setSize(width: GraberView.Constants.width, height: GraberView.Constants.height)
        
        let radius: CGFloat = 20.0
        self.layer.cornerRadius = radius
        
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.layer.masksToBounds = true
        contentView.backgroundColor = .appColors.ui.main
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createCircularCutout()
    }
    
    private func createCircularCutout() {
        contentView.layer.mask = nil
        let rect = CGRect(x: graberView.frame.origin.x - 4,
                          y: -4,
                          width: graberView.frame.size.width + 8,
                          height: graberView.frame.height + 8)
        let circlePath = UIBezierPath(roundedRect: rect, cornerRadius: (graberView.frame.height + 8) / 2)
        
        
        let path = UIBezierPath(rect: bounds)
        path.append(circlePath)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        
        contentView.layer.mask = maskLayer
    }
    
}

open class SheetViewController: CommonViewController {
    
    open override func loadView() {
        let contentView = SheetContentView()
        self.view = contentView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
