//
//  CommonViewController.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 18.09.2024.
//

import UIKit

open class CommonViewController: UIViewController {
    private lazy var loaderView = UIView().forAutoLayout()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .appColors.ui.main
    }
    
    public final func addCloseButton() {
        let closeButton = Button().forAutoLayout()
        closeButton.configure { configuration in
            configuration.primaryFont = .appFonts.secondaryButton
            configuration.primaryTextColor = .appColors.text.blue
            configuration.primaryTextAlignment = .center
            configuration.backgroundColor = .clear
        }
        self.view.addSubview(closeButton)
        closeButton.setSize(width: 120, height: 60)
        closeButton.primaryText = "Закрыть"
        closeButton.addConstraintToSuperView([.top(0), .trailing(0)])
        closeButton.addAction(.init(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
    }
}
