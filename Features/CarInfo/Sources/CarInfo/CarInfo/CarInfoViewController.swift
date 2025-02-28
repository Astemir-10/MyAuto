//
//  CarInfoViewController.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 14.08.2024.
//

import UIKit
import DesignKit

final class CarInfoViewController: CommonViewController, UITextFieldDelegate {
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView().forAutoLayout()
        headerView.set(title: "Нам нужны данные вашего автомобиля",
                       subtitle: "Введите номер государственного регистрационного знака вашего автомобиля или заполните данные вручную")
        return headerView
    }()
    
    private lazy var cardView = {
        let cardView = CardView().forAutoLayout()
        cardView.configure { configuration in
            configuration.spacing = 32
        }
        return cardView
    }()
    
    private lazy var carNumberTextField: TextField = {
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
    
    private lazy var buttonsContainer = {
        let buttonsContainer = ButtonsContainer()
        buttonsContainer.configure { configuration in
            configuration.edgeInsets = .zero
        }
        buttonsContainer.setTitles(primary: "Найти", secondary: "Ввести вручную")
        
        return buttonsContainer
    }()
    
    private lazy var numberStackView: UIStackView = UIStackView().forAutoLayout()
    private lazy var numberTextFieldDescriptionLabel: UILabel = UILabel().forAutoLayout()
    
    var output: CarInfoViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextFieldDescriptionLabel.font = .appFonts.descriptionSmall
        numberTextFieldDescriptionLabel.textColor = .appColors.text.primary
        numberTextFieldDescriptionLabel.text = "Введите номер автомобиля:"
        numberStackView.axis = .vertical
        numberStackView.spacing = 8
        numberStackView.addArrangedSubviews(numberTextFieldDescriptionLabel, carNumberTextField)
        self.view.addSubview(headerView)
        headerView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0)], withSafeArea: true)
        
        self.view.addSubview(cardView)
        cardView.addContentView(numberStackView)
        self.cardView.addConstraintToSuperView([.leading(20), .trailing(-20)])
        self.cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor).activated()
        carNumberTextField.setSize(height: 60)
        carNumberTextField.placeholder = "А 255 КК 07"
        
        cardView.addContentView(buttonsContainer)
        
        self.buttonsContainer.primaryTapHandler { [weak self] in
            self?.view.endEditing(true)
            self?.output.searchCarInfo(by: self?.carNumberTextField.text ?? "")
        }
        
        self.buttonsContainer.secondaryTapHandler { [weak self] in
            self?.output.enterManual()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.carNumberTextField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    
    func formatLicensePlate(_ text: String) -> String {
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
}

extension CarInfoViewController: CarInfoViewInput {

}
