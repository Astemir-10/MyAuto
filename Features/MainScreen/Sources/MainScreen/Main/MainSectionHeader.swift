//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 31.10.2024.
//

import UIKit
import DesignKit

final class MainSectionHeader: UICollectionReusableView {
    private lazy var headerView = HeaderView().forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        headerView.configure { configuration in
            configuration.edgeInsets = .init(top: 12, left: 0, bottom: 12, right: 0)
        }
    }
    
    func setTitle(title: String) {
        headerView.set(title: title)
        self.addSubview(headerView)
        headerView.addFourNullConstraintToSuperView()
    }
}
