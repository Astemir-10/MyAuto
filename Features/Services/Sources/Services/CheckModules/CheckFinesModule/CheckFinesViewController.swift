//
//  File.swift
//  Services
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import UIKit
import DesignKit

final class CheckFinesViewController: CommonViewController {
    
    var output: (CheckFinesViewOutput & CheckViewOutput)!
    
    private lazy var scrollView: UIScrollView = UIScrollView().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addFourNullConstraintToSuperView(withSafeArea: true)
        scrollView.alwaysBounceVertical = true
    }
}

extension CheckFinesViewController: CheckFinesViewInput {
    func setResponse(model: Any) {
        scrollView.subviews.compactMap({ $0 as? CheckViewInput }).first?.setModel(model: model)
    }
    
    func buildForMode(mode: CheckFinesMode) {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        var contentView: UIView & CheckViewInput
        switch mode {
        case .driver:
            contentView = DriverCheckView().forAutoLayout()
        case .fines:
            contentView = FinesCheckView().forAutoLayout()
        case .car:
            contentView = CarCheckView().forAutoLayout()
        }
        contentView.delegate = output
        scrollView.addSubview(contentView)
        contentView.addFourNullConstraintToSuperView()
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).activated()
    }
}
