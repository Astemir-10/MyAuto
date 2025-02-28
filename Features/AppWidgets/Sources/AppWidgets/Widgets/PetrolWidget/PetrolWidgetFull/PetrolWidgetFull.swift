//
//  File.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 05.11.2024.
//

import UIKit
import DesignKit
import GlobalServiceLocator
import AppServices
import Combine

final class PetrolSearchResultCell: UITableViewCell, ConfigurableCell {

    private lazy var petrolView = PetrolView().forAutoLayout()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(petrolView)
        petrolView.addConstraintToSuperView([.top(8), .bottom(-8), .leading(0), .trailing(0)])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with item: PetrolWidgetInfoModel) {
        petrolView.setModel(item)
    }

    
}

final class PetrolSearchResultAdapter: TableViewAdapter<PetrolWidgetInfoModel, PetrolSearchResultCell> {
    
}

final class PetrolSearchResult: CommonViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PetrolSearchResultCell.self, forCellReuseIdentifier: PetrolSearchResultCell.identifier)
        return tableView
    }()
    
    private let adapter = PetrolSearchResultAdapter(items: [])
    let service: PetrolService = GlobalServiceLocator.shared.getService()
    var brand: String?
    var city: String?
    var region: String?
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)], withSafeArea: true)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        request()
    }
    
    func request() {
            
        service.cachedOrRequestedPricesInfo(region: "63")
            .sink(receiveError: { error in
                print(error.localizedDescription)
            }, receiveValue: { [weak self] value in
                let models = value.stations.map({ PetrolWidgetInfoModel($0, longitude: 0, latitude: 0) })
                self?.adapter.updateItems(models)
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
}

final class PetrolParamsSelectedCell: UITableViewCell, ConfigurableCell {

    private lazy var label = UILabel().forAutoLayout()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        label.addConstraintToSuperView([.top(8), .bottom(-8), .leading(8), .trailing(-8)])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with item: (String, String)) {
        label.text = item.1
    }
    
}


final class PetrolParamsSelectedAdapter: TableViewAdapter<(String, String), PetrolParamsSelectedCell> {
    
    var selected: ((String, String) -> ())?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected?(items[indexPath.row].0, items[indexPath.row].1)
    }
}

final class PetrolParamsSelected: CommonViewController {
    enum Mode {
        case region, brand, city
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PetrolParamsSelectedCell.self, forCellReuseIdentifier: PetrolParamsSelectedCell.identifier)
        return tableView
    }()
    
    private let adapter = PetrolParamsSelectedAdapter(items: [])

    let service: PetrolService = GlobalServiceLocator.shared.getService()
    let mode: Mode
    var cancellables: Set<AnyCancellable> = []

    let selected: ((String?, String?) -> ())?
    
    init(mode: Mode, selected: ((String?, String?) -> ())?) {
        self.mode = mode
        self.selected = selected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.addConstraintToSuperView([.top(0), .bottom(0), .leading(0), .trailing(0)], withSafeArea: true)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        adapter.selected = { [weak self] id, str in
            self?.selected?(id, str)
            self?.dismiss(animated: true)
        }
        request()
    }
    
    func request() {
//        switch mode {
//        case .region:
//            service.requestRegionsInfo()
//                .sink(receiveError: { error in
//                    
//                }, receiveValue: { [weak self] value in
//                    self?.adapter.updateItems(value.regions.map({ ($0.id, $0.value) }))
//                    self?.tableView.reloadData()
//
//                })
//                .store(in: &cancellables)
//        case .brand:
//            service.requestBrandsInfo()
//                .sink(receiveError: { error in
//                    
//                }, receiveValue: { [weak self] value in
//                    self?.adapter.updateItems(value.brands.map({ ($0.id, $0.value) }))
//                    self?.tableView.reloadData()
//                })
//                .store(in: &cancellables)
//        case .city:
//            service.requestCitiesInfo()
//                .sink(receiveError: { error in
//                    
//                }, receiveValue: { [weak self] value in
//                    self?.adapter.updateItems(value.cities.map({ ($0.id, $0.value) }))
//                    self?.tableView.reloadData()
//                })
//                .store(in: &cancellables)
//        }
    }
}

final class PetrolWidgetFull: CommonViewController {
    private lazy var region: Button = {
        let btn = Button()
        btn.primaryText = "Регион"
        btn.configure { config in
            config.primaryTextAlignment = .left
        }
        btn.addAction(.init(handler: { [weak self] _ in
            self?.didTapRegion()
        }), for: .touchUpInside)
        return btn
    }()
    
    private lazy var brand: Button = {
        let btn = Button()
        btn.configure { config in
            config.primaryTextAlignment = .left
        }
        btn.primaryText = "Бренд"
        btn.addAction(.init(handler: { [weak self] _ in
            self?.didTapBrand()
        }), for: .touchUpInside)
        return btn
    }()
    
    private lazy var city: Button = {
        let btn = Button()
        btn.configure { config in
            config.primaryTextAlignment = .left
        }
        btn.primaryText = "Город"
        btn.addAction(.init(handler: { [weak self] _ in
            self?.didTapCity()
        }), for: .touchUpInside)
        return btn
    }()
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [region, brand, city])
    private lazy var buttonContainer = ButtonsContainer().forAutoLayout()
    private var brandId: String?
    private var cityId: String?
    private var regionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentStackView)
        self.view.addSubview(buttonContainer)
        contentStackView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0)], withSafeArea: true)
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        
        buttonContainer.addConstraintToSuperView([.leading(0),.trailing(0),.bottom(-20)], withSafeArea: true)
        buttonContainer.setTitles(primary: "Найти")
        
        buttonContainer.primaryTapHandler { [weak self] in
            guard let self else { return }
            let vc = PetrolSearchResult()
            vc.brand = self.brandId
            vc.city = self.cityId
            vc.region = self.regionId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapRegion() {
        let params = PetrolParamsSelected(mode: .region, selected: { [weak self] (id, region) in
            self?.region.primaryText = region
            self?.regionId = id
        })
        self.present(params, animated: true)
    }
    
    func didTapCity() {
        let params = PetrolParamsSelected(mode: .city, selected: { [weak self] (id, city) in
            self?.city.primaryText = city
            self?.cityId = id
        })
        self.present(params, animated: true)

    }
    
    func didTapBrand() {
        let params = PetrolParamsSelected(mode: .brand, selected: { [weak self] (id, brand) in
            self?.brand.primaryText = brand
            self?.brandId = id
        })
        self.present(params, animated: true)

    }
}
