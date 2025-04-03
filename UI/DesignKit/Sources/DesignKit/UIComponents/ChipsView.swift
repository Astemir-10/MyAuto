//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import UIKit

public final class ChipsView: UIControl {
    
    private lazy var textLabel: UILabel = {
        let label = UILabel().forAutoLayout()
        return label
    }()
    
    
    public override var isSelected: Bool {
        didSet {
            didChangeIsSelected()
        }
    }
    
    private var tapActionHandler: ((Bool) -> ())?
    
    public var isDeselectable: Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.addTarget(self, action: #selector(handlerTap), for: .touchUpInside)
        self.addSubview(textLabel)
        textLabel.addConstraintToSuperView([.top(8), .leading(8), .trailing(-8), .bottom(-8)])
        self.backgroundColor = .appColors.ui.gray
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    public func tapAction(_ completion: @escaping (Bool) -> ()) {
        self.tapActionHandler = completion
    }
    
    public func setText(_ text: String) {
        self.textLabel.text = text
    }
    
    @objc
    private func handlerTap() {
        if isDeselectable {
            isSelected.toggle()
        } else {
            if !isSelected {
                isSelected = true
            }
        }
        self.tapActionHandler?(isSelected)
    }
    
    private func didChangeIsSelected() {
        self.backgroundColor = isSelected ? .appColors.ui.primaryButton : .appColors.ui.gray
    }
}
