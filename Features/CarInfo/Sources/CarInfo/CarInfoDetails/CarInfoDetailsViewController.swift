//
//  CarInfoDetailsViewController.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import UIKit
import DesignKit
import DesignTokens

final class CarInfoDetailsViewController: CommonViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain).forAutoLayout()
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(CarInfoDetailsCell.self, forCellReuseIdentifier: "CarInfoDetailsCell")
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.set(title: "Ваш автомобиль", subtitle: "Проверьте полученные данные и введите значение пробега")
        return headerView
    }()
    
    private lazy var cardView: CardView = {
        let cardView = CardView().forAutoLayout()
        return cardView
    }()
    
    private lazy var primaryButtonContainer: ButtonsContainer = {
        let container = ButtonsContainer().forAutoLayout()
        container.setTitles(primary: "Продолжить")
        container.primaryTapHandler { [weak self] in
            self?.output.saveData()
        }
        return container
    }()
    
    private var carModel: CarInfoDetailsModel!
    private var bottomConstraint: NSLayoutConstraint!
    private var bottomConstant: CGFloat = 0
    
    var output: CarInfoDetailsViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        self.addCloseButton()
        self.view.addSubviews(cardView, headerView, primaryButtonContainer)
        self.headerView.addConstraintToSuperView([.top(50), .leading(0), .trailing(0)])
        cardView.addConstraintToSuperView([
                                            .leading(20),
                                            .trailing(-20)], withSafeArea: true)
        self.headerView.bottomAnchor.constraint(equalTo: cardView.topAnchor).activated()
        cardView.addContentView(tableView)
        primaryButtonContainer.addConstraintToSuperView([.leading(0), .trailing(0)], withSafeArea: true)
        primaryButtonContainer.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20).activated()
        bottomConstraint = primaryButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).activated()
        bottomConstant = bottomConstraint.constant
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func tapAction() {
        self.view.endEditing(true)
    }
    
    @objc
    private func willShowKeyboard(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            animateWithKeyboard(notification: notification) {
                self.bottomConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func willHideKeyboard(_ notification: Notification) {
        animateWithKeyboard(notification: notification) {
            self.bottomConstraint.constant = self.bottomConstant
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateWithKeyboard(notification: Notification, animations: @escaping () -> Void) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let options = UIView.AnimationOptions(rawValue: curve << 16)
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }
    }
    
    
}

extension CarInfoDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let carModel, let cell = tableView.dequeueReusableCell(withIdentifier: "CarInfoDetailsCell", for: indexPath) as? CarInfoDetailsCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.setModel(name: "Марка", value: carModel.carBrand.isEmpty ? nil : carModel.carBrand, placeholder: "Tayota", valueIsText: true)
        }
        
        if indexPath.row == 1 {
            cell.setModel(name: "Модель", value: carModel.carModel.isEmpty ? nil : carModel.carModel, placeholder: "Camry", valueIsText: true)
        }
        
        if indexPath.row == 2 {
            cell.setModel(name: "Год выпуска", value: carModel.year.isEmpty ? nil : carModel.year, placeholder: "2011", valueIsText: false)
        }
        
        if indexPath.row == 3 {
            cell.setModel(name: "Мощность, лс", value: carModel.power == 0 ? nil : String(carModel.power), placeholder: "0", valueIsText: false)
        }
        
        if indexPath.row == 4 {
            cell.setModel(name: "Объем двигателя, л", value: carModel.volume == 0 ? nil : String(Double(carModel.volume / 100).rounded() / 10), placeholder: "0", valueIsText: false)
        }
        
        if indexPath.row == 5 {
            cell.setModel(name: "Цвет", value: carModel.color.isEmpty ? nil : carModel.color, placeholder: "Желтый", valueIsText: true)
        }
        
        if indexPath.row == 6 {
            cell.setModel(name: "Пробег, км", value: carModel.mileage == 0 ? nil : String(carModel.mileage), placeholder: "0", valueIsText: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
}

extension CarInfoDetailsViewController: CarInfoDetailsViewInput {
    func setModel(carModel: CarInfoDetailsModel) {
        self.carModel = carModel
    }
}
