//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit
import DesignKit
import CarInfo
import AnyFormatter

enum Service: Int, CaseIterable {
    case obdDiagnostic, carCheck, driverCheck, finesCheck, carСomparator, costEstimation, towTruck
    
    var title: String {
        switch self {
        case .obdDiagnostic:
            "OBD"
        case .carCheck:
            "Проверка авто"
        case .driverCheck:
            "Проверка водителя"
        case .finesCheck:
            "Проверка штрафов"
        case .carСomparator:
            "Сравнить авто"
        case .costEstimation:
            "Оценка стоимости"
        case .towTruck:
            "Срочный эвокуатор"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .obdDiagnostic:
            UIImage.emojiToImage(emoji: "🔍", size: 40)
        case .carCheck:
            UIImage.emojiToImage(emoji: "🚗", size: 40)
        case .driverCheck:
            UIImage.appImages.sfIcons.personFill.withSize(size: 40, weight: .regular).withTintColor(.appColors.ui.main)
        case .finesCheck:
            UIImage.emojiToImage(emoji: "💸", size: 40)
        case .carСomparator:
            UIImage.emojiToImage(emoji: "🚘", size: 40)
        case .costEstimation:
            UIImage.emojiToImage(emoji: "💵", size: 40)
        case .towTruck:
            UIImage.emojiToImage(emoji: "🛻", size: 40)
        }
    }
}

public final class ServicesViewController: CommonViewController {
    
        
    var output: ServicesViewOutput!

    private var services = Service.allCases
    private lazy var scrollView = UIScrollView().forAutoLayout()
    private lazy var contentStackView = UIStackView().forAutoLayout()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
        
    }
    
    private func setupUI() {
        self.title = "Сервисы"
        self.view.addSubview(scrollView)
        scrollView.addFourNullConstraintToSuperView(constant: 8, withSafeArea: true)
        scrollView.addSubview(contentStackView)
        scrollView.alwaysBounceVertical = true
        contentStackView.addFourNullConstraintToSuperView(constant: 8)
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        contentStackView.distribution = .fillEqually
        chunkArray(services, chunkSize: 4).forEach({
            let stackView = UIStackView()
            stackView.axis = .horizontal
            $0.forEach({ service in
                let view = makeServiceView(service: service).forAutoLayout()
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnView(_:))))
                stackView.addArrangedSubview(view)
            })
            stackView.spacing = 8
            stackView.distribution = .fillEqually
            contentStackView.addArrangedSubview(stackView)
        })
        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16).activated()
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -16).activated()
    }
    
    @objc private func tapOnView(_ gesture: UIGestureRecognizer) {
        guard let tag = gesture.view?.tag, let service = Service(rawValue: tag) else {
            return
        }
        output.didTapService(service: service)
    }
    
    private func makeServiceView(service: Service) -> UIView {
        let view = UIView()
        view.tag = service.rawValue
        view.backgroundColor = .appColors.ui.primaryAlternative
        view.layer.cornerRadius = 5
        
        
        let titleView = UILabel().forAutoLayout()
        titleView.text = service.title
        titleView.font = .appFonts.secondaryLarge
        titleView.textColor = .appColors.text.primary
        titleView.numberOfLines = 2
        
        let iconVIew = UIImageView().forAutoLayout()
        iconVIew.clipsToBounds = true
        iconVIew.contentMode = .scaleAspectFit
        iconVIew.image = service.icon
        
        view.addSubviews(iconVIew, titleView)
        
        iconVIew.addConstraintToSuperView([.top(4), .leading(4), .trailing(-4)])
        titleView.addConstraintToSuperView([.bottom(-4), .leading(4), .trailing(-4)])
        titleView.topAnchor.constraint(equalTo: iconVIew.bottomAnchor, constant: 4).activated()
        titleView.textAlignment = .center
        return view
    }
    
    func chunkArray<T>(_ array: [T], chunkSize: Int) -> [[T]] {
        guard chunkSize > 0 else { return [] }
        return stride(from: 0, to: array.count, by: chunkSize).map {
            Array(array[$0..<min($0 + chunkSize, array.count)])
        }
    }
}

extension ServicesViewController: ServicesViewInput {
    func setData(carInfoDetailsModel: CarInfo.CarInfoDetailsModel) {
        
    }
}

