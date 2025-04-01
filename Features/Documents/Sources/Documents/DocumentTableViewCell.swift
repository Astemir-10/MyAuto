//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 14.03.2025.
//

import UIKit
import DesignKit
import CarDocumentRecognizer

final class DocumentTableViewCell: UITableViewCell, SimpleConfigurableCell {
    private lazy var cardView = CardView().forAutoLayout()
    private lazy var cardContentView = UIView()
    
    private lazy var documentImageView: UIImageView = {
        let imageView = UIImageView().forAutoLayout()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var documentType: CarDocumentType?
    private var imageSizeConstraint: NSLayoutConstraint?
    private var imageHeight: CGFloat?
    
    private lazy var labelsStackView = UIStackView().forAutoLayout()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(cardView)
        cardView.configure { configuration in
            configuration.edgeInsets = .zero
            configuration.cornerRadius = 20
        }
        cardView.addConstraintToSuperView([.bottom(-8), .top(8), .leading(8), .trailing(-8)])
        cardView.addContentView(cardContentView)
        self.cardContentView.addSubviews(documentImageView, labelsStackView)
        documentImageView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0)])
        labelsStackView.addConstraintToSuperView([.bottom(-12), .leading(12), .trailing(-12)])
        self.imageSizeConstraint = documentImageView.heightAnchor.constraint(equalToConstant: 200).activated()
        labelsStackView.topAnchor.constraint(equalTo: documentImageView.bottomAnchor, constant: 12).activated()
        labelsStackView.alignment = .leading
        labelsStackView.spacing = 8
        labelsStackView.axis = .vertical
        documentImageView.layer.cornerRadius = 20
        documentImageView.clipsToBounds = true
    }
    
    func configure(with item: DocumentModel) {
        labelsStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        
        if item.id == CarDocumentRecognizerType.driverLicense.id {
            if let driverLicense = try? DriverLicenseModel(from: item.attributes) {
                self.documentType = .driverLicense
                if let surname = driverLicense.surname {
                    labelsStackView.addArrangedSubview(makeLabel(text: surname))
                }
                if let name = driverLicense.name {
                    labelsStackView.addArrangedSubview(makeLabel(text: name))
                }
                
                if let driverDate = driverLicense.driverDate {
                    labelsStackView.addArrangedSubview(makeLabel(text: driverDate.toString(dateForamtter: .simpleFormatter)))
                }
                
                if let startDate = driverLicense.startDate {
                    labelsStackView.addArrangedSubview(makeLabel(text: startDate.toString(dateForamtter: .simpleFormatter)))
                }
                
                if let expiredDate = driverLicense.expiredDate {
                    labelsStackView.addArrangedSubview(makeLabel(text: expiredDate.toString(dateForamtter: .simpleFormatter)))
                }
                
                if let number = driverLicense.number {
                    labelsStackView.addArrangedSubview(makeLabel(text: number))
                }
                
                if let category = driverLicense.category {
                    labelsStackView.addArrangedSubview(makeLabel(text: category))
                }
            }
        } else if item.id == CarDocumentRecognizerType.sts.id {
            if let sts = try? STSModel(from: item.attributes)  {
                documentType = .vrc
                if let vin = sts.vin {
                    labelsStackView.addArrangedSubview(makeLabel(text: vin))
                }
                if let number = sts.number {
                    labelsStackView.addArrangedSubview(makeLabel(text: number))
                }
            }
        }
        
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width - 16
        let ratio = item.image.size.height / item.image.size.width
        let newHeight = maxWidth * ratio
        self.imageHeight = newHeight
        self.documentImageView.image = item.image
        self.imageSizeConstraint?.constant = newHeight
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let imageHeight {
            imageSizeConstraint?.constant = imageHeight
        }
    }
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
    
}
