//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit

final public class GraberView: UIView {
    public enum Constants {
        public static let height: CGFloat = 8
        public static let width: CGFloat = 40
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    private func setupUI() {
        self.backgroundColor = .appColors.ui.gray
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
