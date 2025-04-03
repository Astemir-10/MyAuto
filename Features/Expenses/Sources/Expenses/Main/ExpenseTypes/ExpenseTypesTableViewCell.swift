//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit
import DesignKit

struct ExpenseTypesCellModel {
    let items = ExpenseType.allCases
    let didSelectItem: (ExpenseType) -> ()
}

final class ExpenseTypeView: UIView {
    var type: ExpenseType?
}

final class ExpenseTypesTableViewCell: UITableViewCell, ConfigurableCell {
    
    private lazy var titleLabel = UILabel().forAutoLayout()
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    private var selectExpenseAction: ((ExpenseType) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        self.contentView.addSubview(scrollView)
        self.contentView.addSubview(titleLabel)
        titleLabel.addConstraintToSuperView([.top(0), .leading(12)])
        titleLabel.font = .appFonts.largeMedium
        titleLabel.textColor = .appColors.text.primary
        titleLabel.text = ""
        scrollView.addConstraintToSuperView([.leading(0), .trailing(0), .bottom(-20)])
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).activated()
        scrollView.setSize(height: 136)
        scrollView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.top(0), .leading(0), .bottom(0), .trailing(0)])
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.distribution = .fillProportionally
        contentStackView.alignment = .top
    }
    
    func configure(with item: Any) {
        contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        if let model = item as? ExpenseTypesCellModel {
            var result = [[ExpenseType]]()
            self.selectExpenseAction = model.didSelectItem
            for i in stride(from: 0, to: model.items.count, by: 2) {
                let chunk = Array(model.items[i..<min(i + 2, model.items.count)])
                result.append(chunk)
            }

            
            result.forEach({
                let verticalStack = UIStackView()
                $0.forEach({
                    verticalStack.addArrangedSubview(makeCell(type: $0))
                    
                })
                verticalStack.axis = .vertical
                verticalStack.spacing = 8
                verticalStack.distribution = .equalCentering
                contentStackView.addArrangedSubview(verticalStack)
            })
        }
    }
    
    private func makeCell(type: ExpenseType) -> UIView {
        let view = ExpenseTypeView().forAutoLayout()
        view.type = type
        let stackView = UIStackView().forAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        let label = UILabel().forAutoLayout()
        let image = UIImageView().forAutoLayout()
        image.contentMode = .scaleAspectFit
        image.setSize(width: 28, height: 28)
        stackView.addArrangedSubviews([image, label])
        view.addSubviews(stackView)
        stackView.addConstraintToSuperView([.leading(4), .trailing(-4), .centerY(0)])
        image.image = type.icon
        label.font = .appFonts.secondaryMedium
        label.text = type.title
        label.textAlignment = .center
        label.textColor = .appColors.text.primary
        view.setSize(width: 100, height: 64)
        view.backgroundColor = .appColors.ui.primaryAlternativeSecondary
        view.layer.cornerRadius = 4
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelect)))
        return view
    }
    
    
    @objc
    private func didSelect(_ sender: UITapGestureRecognizer) {
        if let type = (sender.view as? ExpenseTypeView)?.type {
            self.selectExpenseAction?(type)
        }
    }
}
