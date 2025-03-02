//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit

final class MainCarWidgetCell: UICollectionViewCell {
    private lazy var bgView = UIView().forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.contentView.addSubview(bgView)
        bgView.addConstraintToSuperView([.bottom(0), .leading(0), .trailing(0), .top(0)])
    }
    
    func setContentView(view: UIView) {
        bgView.addSubview(view.forAutoLayout())
        view.addConstraintToSuperView([.bottom(0), .leading(0), .trailing(0), .top(0)])
    }    
}
