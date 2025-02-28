//
//  ErrorViewInput.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 16.08.2024.
//

import UIKit

public protocol ErrorViewInput {
    func showFullScreenError(text: String, refreshAction: @escaping () -> ())
    func showFullScreenError(refreshAction: @escaping () -> ())
    func showAlertError(text: String)
    func showCommonAlertError()
    func hideError()
}

public extension ErrorViewInput where Self: UIViewController {
    func showFullScreenError(refreshAction: @escaping () -> ()) {
        hideError()
        let errorVC = ErrorViewController(errorType: .default, action: refreshAction)
        addChildVC(errorVC)
    }
    
    func showFullScreenError(text: String, refreshAction: @escaping () -> ()) {
        hideError()
        let errorVC = ErrorViewController(errorType: .custom(text), action: refreshAction)
        addChildVC(errorVC)
    }
    
    func hideError() {
        self.children.forEach({
            if let errorVC = $0 as? ErrorViewController {
                errorVC.removeFromParentVC()
            }
        })
    }
    
    func showAlertError(text: String) {
        hideError()
        let errorVC = ErrorViewController(errorType: .custom(text), style: .alert, action: nil)
        addChildVC(errorVC)
    }
    
    func showCommonAlertError() {
        hideError()
        let errorVC = ErrorViewController(errorType: .default, style: .alert, action: nil)
        addChildVC(errorVC)
    }
}

final class ErrorViewController: UIViewController {
    enum ErrorViewType {
        case `default`
        case textErrorWithButton
        case custom(String)
    }
    
    enum ErrorViewStyle {
        case alert
        case fullScreen
    }
    
    public init(errorType: ErrorViewType, style: ErrorViewStyle = .fullScreen, action: (() -> ())?) {
        self.errorType = errorType
        self.action = action
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let errorType: ErrorViewType
    private let action: (() -> ())?
    private let style: ErrorViewStyle
    
    private lazy var refreshButton = Button().forAutoLayout()
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var textsStackView = UIStackView()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    private lazy var alertView = UIView().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        if style == .alert {
            self.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        self.view.addSubview(alertView)
        alertView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.top(12), .leading(12), .trailing(-12), .bottom(-12)])
        
        refreshButton.setSize(.medium)
        refreshButton.configure { config in
            config.primaryTextColor = .appColors.text.primary
            config.primaryFont = .appFonts.neutral
        }
        
        refreshButton.primaryText = style == .alert ? "Закрыть" : "Обновить"
        titleLabel.text = "Ошибка"
        titleLabel.font = .appFonts.textLarge
        titleLabel.textColor = .appColors.text.primary
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .appFonts.secondaryLarge
        descriptionLabel.textColor = .appColors.text.primary
        textsStackView.addArrangedSubviews([titleLabel, descriptionLabel])
        textsStackView.axis = .vertical
        textsStackView.alignment = .center
        textsStackView.spacing = 8
        
        contentStackView.addArrangedSubviews([textsStackView])
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.distribution = .equalCentering
        contentStackView.spacing = 16
        alertView.addConstraintToSuperView([.centerX(0), .centerY(0)])
        alertView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8).activated()
        
        if action != nil {
            self.contentStackView.addArrangedSubview(refreshButton)
            refreshButton.addAction(.init(handler: { [weak self] _ in
                self?.action?()
            }), for: .touchUpInside)
        } else if style == .alert {
            self.contentStackView.addArrangedSubview(refreshButton)
            refreshButton.addAction(.init(handler: { [weak self] _ in
                UIView.animate(withDuration: 0.2) {
                    self?.alertView.alpha = 0
                } completion: { _ in
                    self?.removeFromParentVC()
                }

            }), for: .touchUpInside)
        }
        
        switch errorType {
        case .default:
            descriptionLabel.text = style == .alert ? "Пожалуйста повторите попытку" : "Произошла ошибка пожалуйста попробуйте обновить экран"
        case .textErrorWithButton:
            descriptionLabel.text = "Произошла ошибка пожалуйста попробуйте обновить экран"
        case .custom(let string):
            descriptionLabel.text = string
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if style == .alert {
            UIView.animate(
                withDuration: 0.6,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.3,
                options: .curveEaseInOut,
                animations: {
                    self.alertView.transform = .identity
                },
                completion: nil
            )
        }
    }
    
    private func setStyle() {
        switch style {
        case .alert:
            self.view.backgroundColor = .clear
            self.alertView.backgroundColor = .appColors.ui.primaryAlternative
            self.alertView.layer.cornerRadius = 20
        case .fullScreen:
            self.view.backgroundColor = .appColors.ui.primaryAlternative
        }
    }
}
