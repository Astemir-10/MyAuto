//
//  File.swift
//  CarScanner
//
//  Created by Astemir Shibzuhov on 13.04.2025.
//

import UIKit
import DesignKit

struct BLEScannerModel {
    let name: String
    let id: String
}

final class BLEScannerCell: UITableViewCell, SimpleConfigurableCell {
    
    private lazy var titleLabel = UILabel().forAutoLayout()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.addConstraintToSuperView([.top(20), .leading(20), .trailing(-20), .bottom(-20)])
    }
    
    func configure(with item: BLEScannerModel) {
        self.titleLabel.text = item.name
    }
}

class BLEScannerAdapter: SimpleTableViewAdapter<BLEScannerModel, BLEScannerCell> {
    var didSelect: ((Int) -> ())?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(indexPath.row)
    }
}

final class BLEScannerViewController: CommonViewController {
    private lazy var tableView: UITableView = UITableView().forAutoLayout()
    private lazy var adapter = BLEScannerAdapter(items: [])
    var output: BLEScannerViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.addFourNullConstraintToSuperView()
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.register(BLEScannerCell.self, forCellReuseIdentifier: BLEScannerCell.identifier)
        adapter.didSelect = { [weak self] index in
            self?.output.didSelect(index: index)
        }
        output.setup()
        tableView.separatorStyle = .none
    }
}

extension BLEScannerViewController: BLEScannerViewInput {
    func setItems(items: [BLEScannerModel]) {
        adapter.updateItems(items)
        tableView.reloadData()
    }
    
    func dismissVC() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
        
    }
}
