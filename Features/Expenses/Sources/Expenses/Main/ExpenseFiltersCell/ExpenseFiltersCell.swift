//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import UIKit
import DesignKit

enum ExpenseFilter: CaseIterable {
    case all, today, yesterday, week, month, year
    var title: String {
        switch self {
        case .all:
            "Все"
        case .today:
            "Сегодня"
        case .month:
            "Месяц"
        case .year:
            "Год"
        case .yesterday:
            "Вчера"
        case .week:
            "Неделя"
        }
    }
}

struct ExpenseFilterModel {
    let filter: ExpenseFilter
    let isSelected: Bool
}

struct ExpenseFiltersModel {
    let filters: [ExpenseFilterModel]
    let didSelectAction: (ExpenseFilter) -> ()
}

final class ExpenseFiltersCell: UITableViewCell, ConfigurableCell {
    
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var stackView = UIStackView().forAutoLayout()
    private var didSelectFilter: ((ExpenseFilter) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        stackView.axis = .horizontal
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        scrollView.addFourNullConstraintToSuperView()
//        scrollView.setSize(height: 60)
        scrollView.addSubview(stackView)
        stackView.addFourNullConstraintToSuperView()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        stackView.spacing = 12
        scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor).activated()
    }
    
    func configure(with item: Any) {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        if let filters = item as? ExpenseFiltersModel {
            self.didSelectFilter = filters.didSelectAction
            stackView.addArrangedSubviews(filters.filters.map({ makeChips(filter: $0) }))
        }
    }
    
    private func makeChips(filter: ExpenseFilterModel) -> UIView {
        let chips = ChipsView()
        chips.isDeselectable = false
        chips.isSelected = filter.isSelected
        chips.setText(filter.filter.title)
        chips.tapAction { [weak self] isSelected in
            self?.stackView.arrangedSubviews.filter({ $0 != chips }).forEach({ ($0 as? ChipsView)?.isSelected = false })
            self?.didSelectFilter?(filter.filter)
        }
        return chips
    }
}
