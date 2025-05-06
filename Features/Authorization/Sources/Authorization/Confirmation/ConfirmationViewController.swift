//
//  File.swift
//  Authorization
//
//  Created by Astemir Shibzuhov on 05.05.2025.
//

import UIKit
import DesignKit

final class ConfirmationViewController: CommonViewController, UITextFieldDelegate {
    
    var output: ConfirmationViewOutput!
    
    private var codeFields: [TextField] = []
    private let stackView = UIStackView()
    private let timerLabel = UILabel()
    private let confirmButton = Button()
    private let resendButton = Button()
    
    private var timer: Timer?
    private var secondsRemaining = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }

    private func setupUI() {
        // Stack for code fields
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        for _ in 0..<4 {
            let tf = TextField()
            tf.backgroundColor = .appColors.ui.primaryAlternative
            tf.keyboardType = .numberPad
            tf.textAlignment = .center
            tf.font = UIFont.systemFont(ofSize: 24)
            tf.borderStyle = .roundedRect
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            codeFields.append(tf)
            stackView.addArrangedSubview(tf)
        }

        // Timer label
        timerLabel.textAlignment = .center
        timerLabel.font = .appFonts.secondaryLarge
        timerLabel.textColor = .appColors.text.secondary
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)

        // Confirm button
        confirmButton.setSize(.small)
        confirmButton.primaryText = "Подтвердить"
        confirmButton.setBackgroundStyle(.primary)
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.5
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)

        // Resend button
        resendButton.setSize(.small)
        resendButton.primaryText = "Отправить код повторно"
        resendButton.setBackgroundStyle(.empty)
        resendButton.isHidden = true
        resendButton.alpha = 0.0
        resendButton.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resendButton)

        // Layout
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: 220),
            
            timerLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 40),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resendButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 20),
            resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        codeFields.first?.becomeFirstResponder()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let textField = textField as? TextField, let index = codeFields.firstIndex(of: textField) else { return }

        let text = textField.text ?? ""
        if text.count > 1 {
            textField.text = String(text.prefix(1))
        }

        if text.count == 1 {
            if index < codeFields.count - 1 {
                codeFields[index + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else if text.isEmpty, index > 0 {
            codeFields[index - 1].becomeFirstResponder()
        }

        updateConfirmButtonState()
    }

    private func updateConfirmButtonState() {
        let code = codeFields.compactMap { $0.text }.joined()
        confirmButton.isEnabled = code.count == 4
        confirmButton.alpha = code.count == 4 ? 1.0 : 0.5
    }

    @objc private func confirmTapped() {
        let code = codeFields.compactMap { $0.text }.joined()
        output.confirm(code: code)
        // Обработка подтверждения
    }

    @objc private func resendTapped() {
        output.resend()
        // Здесь можно вызвать API для повторной отправки кода
        startTimer()
    }

    private func startTimer() {
        secondsRemaining = 60
        resendButton.isHidden = true
        resendButton.alpha = 0.0
        updateTimerLabel()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        secondsRemaining -= 1
        updateTimerLabel()
        if secondsRemaining <= 0 {
            timer?.invalidate()
            timer = nil
            showResendButton()
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = "Повторный код через \(secondsRemaining) сек"
    }

    private func showResendButton() {
        timerLabel.text = nil
        resendButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.resendButton.alpha = 1.0
        }
    }

    
}

extension ConfirmationViewController: ConfirmationViewInput, ConfirmationModuleInput {
    func setState(state: ConfirmationState) {
        switch state {
        case .loading:
            break
        case .succes:
            self.dismiss(animated: true)
        case .failed:
            break
        }
    }
    
    
}
