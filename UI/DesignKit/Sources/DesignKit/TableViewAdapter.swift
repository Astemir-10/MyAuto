//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 31.03.2025.
//

import UIKit

public protocol ConfigurableCell: UITableViewCell {
    func configure(with item: Any)
}

public protocol ConfigurableHeader: UITableViewHeaderFooterView {
    func configure(with item: Any)
}

public struct AnyTableRow {
    let cellType: ConfigurableCell.Type
    let model: Any
    let deleteAction: ((Any) -> ())?
    
    public init(cellType: ConfigurableCell.Type, model: Any, deleteAction: ((Any) -> ())?) {
        self.cellType = cellType
        self.model = model
        self.deleteAction = deleteAction
    }
}

public struct TableViewSection {
    let headerType: ConfigurableHeader.Type?
    let model: Any?
    var rows: [AnyTableRow]
    
    public init(headerType: ConfigurableHeader.Type?, model: Any?, rows: [AnyTableRow]) {
        self.headerType = headerType
        self.model = model
        self.rows = rows
    }
}

// Универсальный адаптер для таблицы
open class TableViewAdapter {
    private var sections: [TableViewSection] = []
    private let didSelectItem: ((Int, Int) -> Void)?
    private weak var tableView: UITableView?
    private lazy var delegateProxy: TableViewDelegateProxy = TableViewDelegateProxy(sectionsProvider: { [weak self] in self?.sections ?? [] }, didSelectItem: { [weak self] section, index in self?.didSelectItem?(section, index) })

    public init(tableView: UITableView, didSelectItem: ((Int, Int) -> Void)? = nil) {
        self.didSelectItem = didSelectItem
        self.tableView = tableView
        self.tableView?.delegate = delegateProxy
        self.tableView?.dataSource = delegateProxy
        delegateProxy.deleteAdction = { [weak self] section, row in
            guard let self else { return }
            self.sections[section].rows[row].deleteAction?(self.sections[section].rows[row].model)
            self.sections[section].rows.remove(at: row)
            tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
        }
    }
    
    // Обновление данных секций
    public func updateSections(_ newSections: [TableViewSection]) {
        self.sections = newSections
        registerCellsAndHeaders()
        tableView?.reloadData()
    }
    
    // Регистрация всех ячеек и заголовков
    private func registerCellsAndHeaders() {
        for section in sections {
            for row in section.rows {
                tableView?.register(row.cellType, forCellReuseIdentifier: row.cellType.identifier)
            }
            if let headerType = section.headerType {
                tableView?.register(headerType, forHeaderFooterViewReuseIdentifier: String(describing: headerType))
            }
        }
    }
}


private class TableViewDelegateProxy: NSObject, UITableViewDataSource, UITableViewDelegate {
    var deleteAdction: ((Int, Int) -> ())?
    private let sectionsProvider: () -> [TableViewSection]
    private let didSelectItem: ((Int, Int) -> Void)?

    init(sectionsProvider: @escaping () -> [TableViewSection], didSelectItem: ((Int, Int) -> Void)?) {
        self.sectionsProvider = sectionsProvider
        self.didSelectItem = didSelectItem
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sectionsProvider().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsProvider()[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sectionsProvider()[indexPath.section].rows[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: row.cellType.identifier, for: indexPath) as? ConfigurableCell else {
            fatalError("Use configurable Cell")
        }
        
        cell.configure(with: row.model)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem?(indexPath.section, indexPath.row)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerType = sectionsProvider()[section].headerType else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerType)) as? ConfigurableHeader else { return nil }

        header.configure(with: sectionsProvider()[section].model as Any)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        sectionsProvider()[indexPath.section].rows[indexPath.row].deleteAction != nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard sectionsProvider()[indexPath.section].rows[indexPath.row].deleteAction != nil else {
            return nil
        }
        
        return .init(actions: [.init(style: .destructive, title: "Удалить", handler: { [weak self] action, view, completion in
            guard let self else { return }
            self.deleteAdction?(indexPath.section, indexPath.row)
            completion(true)
        })])
    }
}
