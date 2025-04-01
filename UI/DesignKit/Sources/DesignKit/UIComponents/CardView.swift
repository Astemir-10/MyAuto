//
//  CardView.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit
import DesignTokens

public final class CardView: UIView {
    public struct CardViewConfiguration {
        public var cornerRadius: CGFloat = 20
        public var spacing: CGFloat = 16
        public var level: Int = 1
        public var edgeInsets: UIEdgeInsets = .init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    private lazy var contentStackView = UIStackView()
    private var configuration = CardViewConfiguration()
    private var contentConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubviews(contentStackView)
        updateConfiguration()
        self.layer.cornerRadius = 20
        self.backgroundColor = .appColors.ui.primaryAlternative
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
    }
    
    private func configureShadow() {
        if configuration.level == 2 {
            layer.shadowOpacity = 0
        } else if configuration.level == 3 {
            layer.shadowOpacity = 0
        } else {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.08
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 12
            layer.cornerRadius = configuration.cornerRadius
        }
    }

    public func configure(_ configuration: (inout CardViewConfiguration) -> ()) {
        configuration(&self.configuration)
        updateConfiguration()
        self.layer.masksToBounds = false
    }
    
    private func updateConfiguration() {
        contentStackView.removeConstraints(contentConstraints)
        self.removeConstraints(contentConstraints)
        contentConstraints = contentStackView.addConstraintToSuperView([
            .top(self.configuration.edgeInsets.top),
            .leading(self.configuration.edgeInsets.left),
            .trailing(-self.configuration.edgeInsets.right),
            .bottom(-self.configuration.edgeInsets.bottom),
        ])
        self.contentStackView.spacing = configuration.spacing
        self.layer.cornerRadius = configuration.cornerRadius
        
        if configuration.level == 2 {
            layer.shadowColor = UIColor.clear.cgColor
            self.backgroundColor = .appColors.ui.primaryAlternativeSecondary
        }
        
        if configuration.level == 3 {
            layer.shadowColor = UIColor.clear.cgColor
            self.backgroundColor = .appColors.ui.primaryAlternativeThirdty
        }
        
        configureShadow()
    }
    
    public func addContentView(_ contentView: UIView, spacing: CGFloat = 12) {
        self.contentStackView.addArrangedSubview(contentView)
        self.contentStackView.spacing = spacing
    }
    
    public func removeAllContentSubviews() {
        self.contentStackView.subviews.forEach({ $0.removeFromSuperview() })
    }
}
