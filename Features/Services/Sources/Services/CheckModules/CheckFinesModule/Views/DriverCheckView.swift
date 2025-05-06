//
//  File.swift
//  Services
//
//  Created by Astemir Shibzuhov on 02.05.2025.
//

import UIKit
import DesignKit
import AppServices

final class DriverCheckView: UIView, CheckViewInput {
    
    weak var delegate: CheckViewOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func setupUI() {
        
    }
    
    func setModel(model: Any) {
        if let model = model as? DriverModel {
            
        }
    }
}


