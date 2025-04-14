//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import DesignKit
import UIKit

final class CarScannerViewController: CommonViewController {
    
    var output: CarScannerViewOutput!
    private lazy var connectButton = Button().forAutoLayout()
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(connectButton)
        connectButton.addConstraintToSuperView([.top(12), .leading(12), .trailing(-12)], withSafeArea: true)
        connectButton.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -12).activated()
        connectButton.primaryText = "Подключить"
        connectButton.setSize(.medium)
        connectButton.addAction(.init(handler: { [weak self] _ in
            self?.output.didTapConnect()
        }), for: .touchUpInside)
        scrollView.addConstraintToSuperView([.bottom(0), .leading(0), .trailing(0)], withSafeArea: true)
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        scrollView.addSubview(contentStackView)
        contentStackView.addFourNullConstraintToSuperView()
        output.setup()
    }
}

extension CarScannerViewController: CarScannerViewInput {
    func setCommand(command: String) {
        let label = UILabel()
        label.text = command
        contentStackView.addArrangedSubview(label)
    }
    
    
}
