//
//  Button.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit

public final class Button: UIControl {
    
    public enum ButtonSize {
        case large
        case medium
        case small
        case custom(CGFloat)
        
        public var size: CGFloat {
            switch self {
            case .custom(let size):
                size
            case .large:
                54
            case .medium:
                44
            case .small:
                36
            }
        }
    }
    
    public enum CornerStyle {
        case rounded
        case custom(CGFloat)
    }
    
    public struct ButtonConfiguration {
        public var primaryFont: UIFont = .appFonts.premiumButton
        public var secondaryFont: UIFont = .appFonts.premiumButton
        public var primaryTextColor = UIColor.white
        public var secondaryTextColor = UIColor.appColors.text.primaryAppOnDark
        public var cornerStyle: CornerStyle = .custom(10)
        public var primaryTextAlignment = NSTextAlignment.center
        public var secondaryTextAlignment = NSTextAlignment.center
        public var backgroundColor = UIColor.appColors.ui.primaryButton
        public var contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        public var needShadow = false
    }
    
    private lazy var primaryLabel: UILabel = UILabel().forAutoLayout()
    private lazy var secondaryLabel: UILabel = UILabel().forAutoLayout()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView().forAutoLayout()
        return stackView
    }()
    
    private var configuration = ButtonConfiguration()
    private lazy var currentBackgroundColor = self.backgroundColor
    
    public var primaryText: String? {
        didSet {
            self.primaryLabel.text = primaryText
        }
    }
    
    public var secondaryText: String? {
        didSet {
            self.secondaryLabel.text = secondaryText
        }
    }
    
    
    public override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                layer.opacity = 0.9
            } else {
                layer.opacity = 1
            }
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                self.backgroundColor = .gray
            } else {
                self.backgroundColor = self.currentBackgroundColor
            }
        }
    }
    
    private lazy var imageView: UIImageView = UIImageView().forAutoLayout()
    
    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    private var imageTopConstraint: NSLayoutConstraint?
    private var imageLeadingConstraint: NSLayoutConstraint?
    private var imageTrailingConstraint: NSLayoutConstraint?
    private var imageBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if case .rounded = self.configuration.cornerStyle {
            self.layer.cornerRadius = self.frame.height / 2
        }
    }

    private func setupUI() {
        self.addSubview(contentStackView)
        self.topConstraint = self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).activated()
        self.leadingConstraint = self.contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).activated()
        self.trailingConstraint = self.contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).activated()
        self.bottomConstraint = self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).activated()
        
        contentStackView.addArrangedSubview(primaryLabel)
        updateConfiguration()
        contentStackView.isUserInteractionEnabled = false
        configureShadow()
        self.addSubview(imageView)
        
        self.imageTopConstraint = self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).activated()
        self.imageLeadingConstraint = self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).activated()
        self.imageTrailingConstraint = self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).activated()
        self.imageBottomConstraint = self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).activated()

    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        
        if self.backgroundColor == .clear {
            layer.shadowOpacity = 0
        }
    }
    
    private func updateConfiguration() {
        self.primaryLabel.font = configuration.primaryFont
        self.primaryLabel.textColor = configuration.primaryTextColor
        self.primaryLabel.textAlignment = configuration.primaryTextAlignment
        self.backgroundColor = configuration.backgroundColor
        self.currentBackgroundColor = configuration.backgroundColor
        switch configuration.cornerStyle {
        case .rounded:
            self.layer.cornerRadius = self.frame.height / 2
        case .custom(let cornerRadius):
            self.layer.cornerRadius = cornerRadius
        }
        if configuration.needShadow {
            configureShadow()
        } else {
            if self.backgroundColor == .clear {
                layer.shadowOpacity = 0
            }
        }
        
        topConstraint?.constant = configuration.contentInsets.top
        leadingConstraint?.constant = configuration.contentInsets.left
        trailingConstraint?.constant = -configuration.contentInsets.right
        bottomConstraint?.constant = -configuration.contentInsets.bottom
        
        imageTopConstraint?.constant = configuration.contentInsets.top
        imageLeadingConstraint?.constant = configuration.contentInsets.left
        imageTrailingConstraint?.constant = -configuration.contentInsets.right
        imageBottomConstraint?.constant = -configuration.contentInsets.bottom
        
        self.imageView.tintColor = configuration.primaryTextColor
        
    }
    
    public func configure(_ configuration: (inout ButtonConfiguration) -> ()) {
        configuration(&self.configuration)
        updateConfiguration()
    }
    
    public func setSize(_ size: ButtonSize) {
        self.setSize(height: size.size)
    }
    
    public func setImage(_ image: UIImage) {
        self.imageView.image = image
    }

//    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if self.point(inside: point, with: nil) {
//            return self
//        }
//        return super.hitTest(point, with: event)
//    }
}
