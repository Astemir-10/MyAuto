//
//  File.swift
//  Expenses
//
//  Created by Astemir Shibzuhov on 03.04.2025.
//

import UIKit
import DesignKit

final class PetrolExpenseCell: UITableViewCell, SimpleConfigurableCell {
    
    private lazy var backgroundContentView = UIView().forAutoLayout()
    private lazy var petrolNameLabel: UILabel = UILabel().forAutoLayout()
    private lazy var petrolCitynameLabel: UILabel = UILabel().forAutoLayout()
    private lazy var contentStackView: UIStackView = UIStackView().forAutoLayout()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(backgroundContentView)
        backgroundContentView.addConstraintToSuperView([.top(8), .leading(8), .bottom(-8), .trailing(-8)])
        backgroundContentView.layer.cornerRadius = 10
        backgroundContentView.backgroundColor = .appColors.ui.primaryAlternativeSecondary
        backgroundContentView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.top(8), .leading(8), .bottom(-8), .trailing(-8)])
        contentStackView.addArrangedSubview(petrolNameLabel)
        contentStackView.addArrangedSubview(petrolCitynameLabel)
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.alignment = .leading
        petrolNameLabel.textColor = .appColors.text.primary
        petrolNameLabel.font = .appFonts.neutralMedium
        contentStackView.spacing = 8
    }
    
    func configure(with item: PetrolExpense.PetrolStation) {
        contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        contentStackView.addArrangedSubview(petrolNameLabel)
        contentStackView.addArrangedSubview(petrolCitynameLabel)
        petrolNameLabel.text = item.name
        petrolCitynameLabel.text = item.cityName
        contentStackView.addArrangedSubview(makePrices(items: item.petrolTypes))
    }
    
    private func makePrices(items: [PetrolExpense.PetrolTypeItem]) -> UIView {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 8
    
        stackView.addArrangedSubviews(items.map({ makePrice(item: $0) }))
        return stackView
    }
    
    private func makePrice(item: PetrolExpense.PetrolTypeItem) -> UIView {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 4
        backgroundView.backgroundColor = .appColors.ui.primaryAlternativeThirdty
        let stack = UIStackView()
        backgroundView.addSubview(stack)
        stack.addConstraintToSuperView([.top(4), .leading(4), .trailing(-4), .bottom(-4)])
        stack.spacing = 4
        stack.alignment = .center
        stack.axis = .vertical
        let nameLabel = UILabel()
        nameLabel.font = .appFonts.secondaryNeutral
        nameLabel.textColor = .appColors.text.primary
        let priceLabel = UILabel()
        priceLabel.font = .appFonts.secondaryMedium
        priceLabel.textColor = .appColors.text.primary

        stack.addArrangedSubviews(nameLabel, priceLabel)
        nameLabel.text = item.petrolType.titel
        priceLabel.text = item.priceOnLiter.format(.currency)
        return backgroundView
    }
}

final class PetrolsListTableViewAdapter: SimpleTableViewAdapter<PetrolExpense.PetrolStation, PetrolExpenseCell > {
    
}

final class PetrolsListViewController: CommonViewController {
    
    var output: PetrolsListViewOutput!
    
    private lazy var tableView = UITableView().forAutoLayout()
    private lazy var adapter = PetrolsListTableViewAdapter(items: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "АЗС"
        view.addSubview(tableView)
        tableView.addFourNullConstraintToSuperView()
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.separatorStyle = .none
        tableView.register(PetrolExpenseCell.self, forCellReuseIdentifier: PetrolExpenseCell.identifier)
        output.setup()
    }
    
    
}

extension PetrolsListViewController: PetrolsListViewInput {
    func setState(_ state: PetrolsListScreenState) {
        switch state {
        case .loading:
            break
        case .loaded(let array):
            adapter.updateItems(array)
            tableView.reloadData()
        case .error:
            break
        }
    }
}
