//
//  LoaderViewInput.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 16.08.2024.
//

import UIKit

public protocol LoaderViewInput {
    func showLoader()
    func hideLoader()
}

public extension LoaderViewInput where Self: UIViewController {
    func showLoader() {
        hideLoader()
        let loaderView = LoaderView()
        addChildVC(loaderView)
    }
    
    func hideLoader() {
        self.children.forEach({
            if let loaderVC = $0 as? LoaderView {
                loaderVC.removeFromParentVC()
            }
        })
    }
}

final class LoaderView: UIViewController {
    private lazy var loaderView = UIView().forAutoLayout()
    private var timeout: TimeInterval = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingContentView = UIStackView().forAutoLayout()
        let background = UIView().forAutoLayout()
        let loadingBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        background.addSubview(loadingBackgroundView)
        background.clipsToBounds = true
        background.layer.cornerRadius = 8
        loadingBackgroundView.addFourNullConstraintToSuperView()
        loadingContentView.axis = .vertical
        loadingContentView.spacing = 8
        loadingContentView.distribution = .fill
        loadingContentView.alignment = .center
        let label = UILabel().forAutoLayout()
        label.text = "Получаем данные"
        label.textColor = .appColors.text.primary
        label.font = .appFonts.neutral
        let loader = UIActivityIndicatorView(style: .large).forAutoLayout()
        loader.startAnimating()
        loader.setSize(width: 50)
        loadingContentView.addArrangedSubview(loader)
        loadingContentView.addArrangedSubview(label)
        loadingBackgroundView.contentView.addSubview(loadingContentView)
        loadingContentView.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8), .bottom(-8)])
        loaderView.addSubview(background)
        background.addConstraintToSuperView([.centerX(0), .centerY(0)])
        loaderView.isUserInteractionEnabled = false
        self.view.addSubview(loaderView)
        loaderView.addFourNullConstraintToSuperView()
        loaderView.backgroundColor = .black.withAlphaComponent(0.2)
        
        Timer.scheduledTimer(timeInterval: timeout, target: self, selector: #selector(timeoutHandler), userInfo: nil, repeats: false)
    }
    
    @objc
    private func timeoutHandler() {
        self.removeFromParentVC()
    }
    
}
