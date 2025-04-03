//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 02.04.2025.
//

import UIKit
import DesignKit
import DesignTokens
import AnyFormatter

struct TotalExpensesModel {
    let fullSum: Double
    let startDate: Date?
    let endDate: Date?
    let filter: ExpenseFilter
    let analyticAction: () -> ()
}

final class TotalExpensesCell: UITableViewCell, ConfigurableCell {
    
    private lazy var totlExpensesLabel: UILabel = UILabel().forAutoLayout()
    private lazy var descriptionLabel: UILabel = UILabel().forAutoLayout()
    private lazy var analyticButton: Button = Button().forAutoLayout()
    private var analyticAction: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubviews(totlExpensesLabel, descriptionLabel, analyticButton)
        totlExpensesLabel.addConstraintToSuperView([.leading(20), .trailing(-20)])
        
        descriptionLabel.addConstraintToSuperView([.leading(20), .trailing(-20), .top(20)])
        descriptionLabel.bottomAnchor.constraint(equalTo: totlExpensesLabel.topAnchor, constant: -8).activated()
        analyticButton.topAnchor.constraint(equalTo: totlExpensesLabel.bottomAnchor, constant: 12).activated()
        analyticButton.addConstraintToSuperView([.bottom(-20), .leading(20), .trailing(-20)])
        
        analyticButton.primaryText = "Аналитика"
        analyticButton.setSize(.medium)
        analyticButton.addAction(.init(handler: { _ in
            
        }), for: .touchUpInside)
        
        totlExpensesLabel.textColor = .appColors.text.primary
        totlExpensesLabel.font = .appFonts.textBold
        analyticButton.setBackgroundStyle(.secondary)
//        analyticButton.setImage(.appImages.sfIcons.analytic.icon) MARK: ДОДЕЛАТЬ
        
        analyticButton.addAction(.init(handler: { [weak self] _ in
            self?.analyticAction?()
        }), for: .touchUpInside)
    }
    
    func configure(with item: Any) {
        if let model = item as? TotalExpensesModel {
            totlExpensesLabel.text = model.fullSum.format(.currency)
            let period: String
            switch model.filter {
                
            case .all:
                if let startDate = model.startDate, let endDate = model.endDate {
                    period = formatDateRange(startDate: startDate, endDate: endDate)
                } else {
                    period = ""
                }

            case .today:
                period = "Сегодня"
            case .yesterday:
                period = "Вчера"
            case .week:
                period = "Эту неделю"
            case .month:
                period = "Этот месяц"
            case .year:
                period = "Этот год"
            }
            self.analyticAction = model.analyticAction
            descriptionLabel.text = "Сумма трат за \(period):"
     
        }
    }
    
    private func formatDateRange(startDate: Date, endDate: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter.simpleFormatter
        let startString = dateFormatter.string(from: startDate)
        let endString = dateFormatter.string(from: endDate)
        return "\(startString) - \(endString)"
    }
}

