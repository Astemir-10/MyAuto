//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 15.04.2025.
//

import UIKit
import DesignKit

final class ConsoleVC: CommonViewController {
    var commands: [String] = []
    
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    private lazy var contentLabel = UILabel().forAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.text = ""
        self.view.addSubview(scrollView)
        scrollView.addFourNullConstraintToSuperView(withSafeArea: true)
        scrollView.addSubview(contentStackView)
        contentStackView.addFourNullConstraintToSuperView()
        contentStackView.addArrangedSubview(contentLabel)
        
        commands.forEach({
            contentLabel.text! += "\($0)\n\n"
        })
    }
}
