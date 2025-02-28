//
//  CarInfoDetailsCell.swift
//  CarInfo
//
//  Created by Astemir Shibzuhov on 27.10.2024.
//

import UIKit
import DesignKit
import DesignTokens

final class CarInfoDetailsCell: UITableViewCell, UITextFieldDelegate {
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel().forAutoLayout()
        lbl.font = .appFonts.neutralMedium
        lbl.textColor = .appColors.text.primary
        return lbl
    }()
    
    private lazy var textField: TextField = {
        let textField = TextField()
        textField.configure { configuration in
            configuration.cornerRadius = 0
            configuration.font = .appFonts.neutral
            configuration.textAlignment = .right
            configuration.textColor = .appColors.text.primary
        }
        return textField.forAutoLayout()
    }()
    
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        textField.delegate = self
        self.contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(nameLabel, textField)
        contentStackView.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8), .bottom(0)])
        contentStackView.alignment = .center
        contentStackView.spacing = 20
        textField.setSize(height: 50)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    func setModel(name: String, value: String? = nil, placeholder: String, valueIsText: Bool) {
        self.nameLabel.text = name
        self.textField.text = value
        self.textField.placeholder = placeholder
        if value == nil {
            nameLabel.textColor = .red
        }
        if !valueIsText {
            self.textField.keyboardType = .numberPad
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            nameLabel.textColor = .red
        } else {
            nameLabel.textColor = .appColors.text.primary
        }
        return true
    }
}
