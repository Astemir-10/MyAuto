//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit

final class MainCarWidgetCell: UICollectionViewCell {
    private lazy var cardView: CardView = CardView().forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.contentView.addSubview(cardView)
        cardView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0), .bottom(0)])
        
        
        cardView.backgroundColor = .orange
        cardView.setSize(height: 100)
    }
}
