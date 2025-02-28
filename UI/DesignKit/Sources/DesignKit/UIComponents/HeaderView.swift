//
//  HeaderView.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 14.08.2024.
//

import UIKit

public final class HeaderView: UIView {
    public enum HeaderSize {
        case small, medium, large
    }
    
    public struct HeaderViewConfiguration {
        public var spacing: CGFloat = 16
        public var edgeInsets: UIEdgeInsets = .init(top: 20, left: 20, bottom: 20, right: 20)
        public var titleFont: UIFont = .appFonts.titleLarge
        public var subtitleFont: UIFont = .appFonts.secondaryLarge
        public var titleColor: UIColor = .appColors.text.primary
        public var subtitleColor: UIColor = .appColors.text.secondary
    }
    
    private lazy var titlelabel: UILabel = {
        let label = UILabel().forAutoLayout()
        label.font = .appFonts.titleLarge
        let titleColor: UIColor = .appColors.text.secondary
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var subtitlelabel: UILabel = {
        let label = UILabel().forAutoLayout()
        label.font = .appFonts.secondaryLarge
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView().forAutoLayout()
        stackView.axis = .vertical
        return stackView
    }()
    
    private var configuration = HeaderViewConfiguration()
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
        self.addSubview(contentStackView)
        updateConfiguration()
    }
    
    public func set(title: String? = nil, subtitle: String? = nil) {
        self.contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        if let title {
            self.titlelabel.text = title
            contentStackView.addArrangedSubview(titlelabel)
        }
        
        if let subtitle {
            self.subtitlelabel.text = subtitle
            self.contentStackView.addArrangedSubview(subtitlelabel)
        }
    }
    
    public func configure(_ configuration: (inout HeaderViewConfiguration) -> ()) {
        configuration(&self.configuration)
        updateConfiguration()
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
        self.titlelabel.font = configuration.titleFont
        self.titlelabel.textColor = configuration.titleColor
        
        self.subtitlelabel.font = configuration.subtitleFont
        self.subtitlelabel.textColor = configuration.subtitleColor
        self.contentStackView.spacing = configuration.spacing
        
    }
}
