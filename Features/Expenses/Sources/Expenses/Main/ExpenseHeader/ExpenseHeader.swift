//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import UIKit
import DesignKit
import AnyFormatter

struct ExpenseHeaderModel {
    let date: Date
}

final class ExpenseHeaderView: UITableViewHeaderFooterView, ConfigurableHeader {
    
    private lazy var titleLabel = UILabel().forAutoLayout()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.contentView.addSubview(titleLabel)
        titleLabel.addConstraintToSuperView([.leading(20), .top(8), .bottom(-12), .trailing(-20)])
        titleLabel.font = .appFonts.textMedium
        titleLabel.textColor = .appColors.text.primary
    }
    
    func configure(with item: Any) {
        if let model = item as? ExpenseHeaderModel {
            self.titleLabel.text = SmartDateFormatter.string(from: model.date)
        }
    }
}
