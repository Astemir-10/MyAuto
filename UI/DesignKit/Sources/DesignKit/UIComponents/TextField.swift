//
//  TextField.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit
import DesignTokens

public final class TextField: UITextField {
    public struct TextFieldConfigureation {
        public var textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        public var textColor = UIColor.appColors.text.primary
        public var placeholderColor = UIColor.appColors.text.secondaryLight
        public var cornerRadius: CGFloat = 10
        public var font: UIFont = .appFonts.neutral
        public var textAlignment: NSTextAlignment = .left
        public var borderWidth: CGFloat = 0
        public var borderColor = UIColor.appColors.ui.secondaryUI
    }
    
    private var configuration = TextFieldConfigureation()
    public override var placeholder: String? {
        didSet {
            self.updatePlaceholderConfiguration()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    private func setupUI() {
        updateConfiguration()
    }
    
    // Текстовые границы
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: configuration.textInsets)
    }
    
    // Границы текста во время редактирования
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: configuration.textInsets)
    }
    
    // Границы плейсхолдера
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: configuration.textInsets)
    }
    
    public func configure(_ configuration: (inout TextFieldConfigureation) -> ()) {
        configuration(&self.configuration)
        updateConfiguration()
    }

    
    private func updateConfiguration() {
        self.layer.cornerRadius = self.configuration.cornerRadius
        self.textAlignment = configuration.textAlignment
        self.textColor = configuration.textColor
        self.font = configuration.font
        self.layer.borderWidth = configuration.borderWidth
        self.layer.borderColor = configuration.borderColor.cgColor
        updatePlaceholderConfiguration()
    }
    
    private func updatePlaceholderConfiguration() {
        guard let placeholderText = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: configuration.placeholderColor,
                         NSAttributedString.Key.font: configuration.font
                        ]
        )
    }
}
