//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 14.03.2025.
//

import DesignKit
import UIKit
import CarDocumentRecognizer

final class DocumentTypesSheet: SheetViewController {
    
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var stackView = UIStackView().forAutoLayout()
    private let documenTypes = CarDocumentRecognizerType.allCases
    var didSelectAction: ((CarDocumentRecognizerType) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appColors.ui.main
        self.view.addSubview(scrollView)
        scrollView.addConstraintToSuperView([.top(20), .leading(20), .trailing(-20), .bottom(-20)])
        scrollView.addSubview(stackView)
        stackView.addFourNullConstraintToSuperView()
        stackView.axis = .vertical
        stackView.spacing = 8

        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).activated()
        documenTypes.map({ $0.title }).enumerated().forEach({
            let btn = makeButton(title: $0.element, tag: $0.offset).forAutoLayout()
            stackView.addArrangedSubview(btn)
            btn.widthAnchor.constraint(equalTo: stackView.widthAnchor).activated()
        })
    }
    
    func makeButton(title: String, tag: Int) -> UIView {
        let button = UIView().forAutoLayout()
        button.tag = tag
        let titleLabel = UILabel().forAutoLayout()
        button.addSubview(titleLabel)
        titleLabel.font = .appFonts.neutralMedium
        titleLabel.text = title
        titleLabel.textColor = .appColors.text.primary
        titleLabel.addConstraintToSuperView([.top(8), .leading(8), .bottom(-8), .trailing(-8)])
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        button.addGestureRecognizer(gesture)
        button.backgroundColor = .appColors.ui.primaryAlternative
        button.layer.cornerRadius = 8
        return button.forAutoLayout()
    }
    
    @objc
    private func handleTap(gesture: UITapGestureRecognizer) {
        if let tag = gesture.view?.tag {            
            self.dismiss(animated: true) { [weak self] in
                self?.didSelectAction?(self?.documenTypes[tag] ?? .driverLicense)
            }
        }
    }
}
