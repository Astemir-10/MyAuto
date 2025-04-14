//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit
import DesignKit

final class ExpensesTableViewCell: UITableViewCell, ConfigurableCell {
    

    private lazy var backgroundCardView = UIView().forAutoLayout()
    private lazy var contetntStackView = UIStackView().forAutoLayout()
    private lazy var namePriceStackView = UIStackView().forAutoLayout()
    private lazy var namePriceVStackView = UIStackView().forAutoLayout()
    private lazy var namePriceIconStackView = UIStackView().forAutoLayout()
    private lazy var priceLabel = UILabel().forAutoLayout()
    private lazy var nameLabel = UILabel().forAutoLayout()
    private lazy var timeLabel = UILabel().forAutoLayout()
    private lazy var iconImageView = UIImageView().forAutoLayout()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        self.separatorInset = .zero
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        self.contentView.addSubview(backgroundCardView)
        backgroundCardView.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8), .bottom(-8)])
        backgroundCardView.backgroundColor = .appColors.ui.primaryAlternativeThirdty
        backgroundCardView.layer.cornerRadius = 8
        contetntStackView.axis = .vertical
        
        backgroundCardView.addSubview(contetntStackView)
        contetntStackView.addConstraintToSuperView([.top(8), .leading(8), .trailing(-16), .bottom(-8)])
        
        namePriceStackView.axis = .horizontal
        namePriceStackView.spacing = 12
        namePriceStackView.distribution = .fill
        namePriceStackView.alignment = .fill
        namePriceStackView.addArrangedSubviews(nameLabel, priceLabel)
        namePriceIconStackView.addArrangedSubview(iconImageView)
        contetntStackView.addArrangedSubview(namePriceIconStackView)
        namePriceIconStackView.addArrangedSubview(namePriceVStackView)
        namePriceVStackView.addArrangedSubview(namePriceStackView)
        namePriceVStackView.addArrangedSubview(timeLabel)
        namePriceVStackView.alignment = .leading
        namePriceStackView.widthAnchor.constraint(equalTo: namePriceVStackView.widthAnchor).activated()
        
        namePriceVStackView.axis = .vertical
        namePriceVStackView.spacing = 8
        namePriceIconStackView.axis = .horizontal
        namePriceIconStackView.alignment = .center
        namePriceIconStackView.spacing = 8
        iconImageView.setSize(width: 28, height: 28)
        
        priceLabel.font = .appFonts.neutralMedium
        priceLabel.textColor = .appColors.text.primary
        
        nameLabel.font = .appFonts.secondaryLarge
        nameLabel.textColor = .appColors.text.primary
        
        timeLabel.textColor = .appColors.text.secondary
        timeLabel.font = .appFonts.secondaryLarge
    }
    
    func configure(with item: Any) {
        if let model = item as? ExpenseModelProtocol {
            switch model.type {
                
            case .petrol:
                break
            case .service:
                break
            case .wash:
                break
            case .insurance:
                break
            case .taxes:
                break
            case .parking:
                break
            case .fines:
                break
            case .qrCode:
                break
            }
            
            if let model = item as? CommonExpense {
                priceLabel.text = model.sum.format(.currency)
                priceLabel.textAlignment = .right
                nameLabel.text = model.type.title
                iconImageView.image = model.type.icon
                timeLabel.text = model.date.toString(dateForamtter: .timeFormatter)
            }
        }
    }
}
