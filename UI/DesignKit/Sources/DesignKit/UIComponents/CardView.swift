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
        public var spacing: CGFloat = 16
        public var edgeInsets: UIEdgeInsets = .init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    private lazy var contentStackView = UIStackView()
    private var configuration = CardViewConfiguration()
    private var contentConstraints = [NSLayoutConstraint]()
    
    public var isSecondLevel: Bool = false {
        didSet {
            if isSecondLevel {
                layer.shadowColor = UIColor.clear.cgColor
                self.backgroundColor = .appColors.ui.primaryAlternativeSecondary
            }
        }
    }
    
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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 15
        layer.cornerRadius = 10
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
        configureShadow()
    }
    
    public func addContentView(_ contentView: UIView, spacing: CGFloat = 12) {
        self.contentStackView.addArrangedSubview(contentView)
        self.contentStackView.spacing = spacing
    }
}
