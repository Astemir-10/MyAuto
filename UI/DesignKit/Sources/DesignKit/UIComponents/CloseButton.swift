//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit

public final class CloseButton: UIControl {
    private lazy var closeImageView: UIImageView = UIImageView().forAutoLayout()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public var closeAction: (() -> ())?
    
    private func setupUI() {
        self.addSubviews(closeImageView)
        self.closeImageView.addFourNullConstraintToSuperView()
        closeImageView.setSize(width: 40, height: 40)
        closeImageView.image = .appImages.icons.close
        self.addAction(.init(handler: { [weak self] _ in
            self?.closeAction?()
        }), for: .touchUpInside)
    }
}

