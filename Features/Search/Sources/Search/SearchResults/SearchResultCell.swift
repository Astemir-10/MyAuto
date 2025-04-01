//
//  File.swift
//  Search
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit
import DesignKit

final class SearchResultCell: UICollectionViewCell, SimpleConfigurableCell {
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
        titleLabel.addFourNullConstraintToSuperView()
    }
    
    func configure(with item: SearchResultItem) {
        if let item = item as? SearchResultModel {
            self.titleLabel.text = item.title
        }
    }
}
