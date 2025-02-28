//
//  File.swift
//  Search
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit
import DesignKit

final class SearchResultCell: UICollectionViewCell, ConfigurableCell {
    private lazy var titleLabel = UILabel().forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.contentView.addSubview(titleLabel)
        titleLabel.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)])
    }
    
    func configure(with item: SearchResultItem) {
        if let item = item as? SearchResultModel {
            self.titleLabel.text = item.title
        }
    }
}
