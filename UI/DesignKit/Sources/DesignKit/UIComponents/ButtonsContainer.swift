//
//  ButtonsContainer.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit

public final class ButtonsContainer: UIView {
    public struct ButtonsContainerConfiguration {
        public var edgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private lazy var primaryButton = Button().forAutoLayout()
    private lazy var secondaryButton = Button().forAutoLayout()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView.forAutoLayout()
    }()
    
    private var configuration = ButtonsContainerConfiguration()
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
        contentConstraints = contentStackView.addConstraintToSuperView([.leading(20), .trailing(20), .top(0), .bottom(0)])
        self.contentStackView.addArrangedSubviews(primaryButton, secondaryButton)
        primaryButton.setSize(height: 54)
        secondaryButton.setSize(height: 54)

        secondaryButton.configure { configuration in
            configuration.backgroundColor = .clear
            configuration.primaryFont = .appFonts.secondaryButton
            configuration.primaryTextColor = .appColors.text.blue
        }
        updateConfiguration()
    }
    
    private func updateConfiguration() {
        self.contentStackView.removeConstraints(contentConstraints)
        self.removeConstraints(contentConstraints)
        contentConstraints = contentStackView.addConstraintToSuperView([.leading(configuration.edgeInsets.left),
                                                   .trailing(-configuration.edgeInsets.right),
                                                   .top(configuration.edgeInsets.top),
                                                   .bottom(-configuration.edgeInsets.bottom)])
    }
    
    public func configure(_ configuration: (inout ButtonsContainerConfiguration) -> ()) {
        configuration(&self.configuration)
        updateConfiguration()
    }
    
    public func primaryTapHandler(_ handler: @escaping () -> ()) {
        primaryButton.addAction(UIAction.init(handler: { _ in
            handler()
        }), for: .touchUpInside)
    }
    
    public func secondaryTapHandler(_ handler: @escaping () -> ()) {
        secondaryButton.addAction(UIAction.init(handler: { _ in
            handler()
        }), for: .touchUpInside)
    }
    
    public func setTitles(primary: String? = nil, secondary: String? = nil) {
        if let primary {
            self.primaryButton.primaryText = primary
        }
        
        if let secondary {
            self.secondaryButton.primaryText = secondary
        } else {
            secondaryButton.removeFromSuperview()
        }
    }
}
