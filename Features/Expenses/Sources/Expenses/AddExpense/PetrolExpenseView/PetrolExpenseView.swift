//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import UIKit
import DesignKit

final class PetrolExpenseView: UIView {
    
    private lazy var petrolView: UIView = UIView().forAutoLayout()
    private lazy var petrolNameLabel = UILabel().forAutoLayout()
    private var tapPetrolAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        addSubview(petrolView)
        petrolView.addFourNullConstraintToSuperView()
        petrolView.addSubview(petrolNameLabel)
        petrolNameLabel.addFourNullConstraintToSuperView()
        petrolView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPetrol)))
        petrolNameLabel.text = "Не выбрано"
    }
    
    @objc
    private func tapPetrol() {
        tapPetrolAction?()
    }
    
    func tapPetrolHandler(_ action: @escaping () -> ()) {
        self.tapPetrolAction = action
    }
    
    func setPetrol(petrol: PetrolExpense.PetrolStation) {
        self.petrolNameLabel.text = petrol.name
    }
    
}
