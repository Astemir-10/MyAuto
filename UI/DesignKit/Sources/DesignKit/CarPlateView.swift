//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import UIKit

public final class CarPlateView: UIView, UITextFieldDelegate {
    
    private lazy var textField: TextField = {
        let textField = TextField().forAutoLayout()
        textField.configure { configuration in
            configuration.textAlignment = .center
            configuration.font = .appFonts.largeMedium
            configuration.textColor = .appColors.text.primaryAppOnDark
            configuration.borderWidth = 1
        }
        textField.backgroundColor = .white
        textField.delegate = self
        return textField
    }()
    
    public var number: String {
        textField.text?.replacingOccurrences(of: " ", with: "") ?? ""
    }
    
    private var didTapReturnAction: (() -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func setupUI() {
        addSubview(textField)
        textField.addFourNullConstraintToSuperView()
        textField.setSize(height: 60)
        textField.placeholder = "А 123 АА 777"
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ограничиваем максимальную длину до 9 символов (без учета пробелов)
        let maxLength = 9
        let currentText = textField.text ?? ""
        
        // Создаем новый текст на основе текущего текста и заменяющей строки
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let filteredText = updatedText.replacingOccurrences(of: " ", with: "")
        
        if filteredText.count > maxLength {
            return false
        }
        
        // Форматируем текст с пробелами
        let formattedText = formatLicensePlate(filteredText)
        textField.text = formattedText
        
        // Перемещаем курсор после ввода
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: formattedText.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        // Возвращаем false, чтобы текстовое поле не обновлялось автоматически, а обновлялось с помощью нашего кода
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.didTapReturnAction?()
        return true
    }
    
    private func formatLicensePlate(_ text: String) -> String {
        var formattedText = text
        
        if formattedText.count > 1 {
            formattedText.insert(" ", at: formattedText.index(formattedText.startIndex, offsetBy: 1))
        }
        if formattedText.count > 5 {
            formattedText.insert(" ", at: formattedText.index(formattedText.startIndex, offsetBy: 5))
        }
        if formattedText.count > 8 {
            formattedText.insert(" ", at: formattedText.index(formattedText.startIndex, offsetBy: 8))
        }
        
        return formattedText.uppercased()
    }
    
    public func didTapReturn(_ handler: @escaping () -> ()) {
        self.didTapReturnAction = handler
    }
}
