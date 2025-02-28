//
//  TableViewAdapter.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 05.11.2024.
//

import UIKit

open class TableViewAdapter<ItemType, CellType: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where CellType: ConfigurableCell, CellType.ItemType == ItemType {
    
    public private(set) var items: [ItemType]
    private let didSelectItem: ((ItemType) -> Void)?

    public init(
        items: [ItemType],
        didSelectItem: ((ItemType) -> Void)? = nil
    ) {
        self.items = items
        self.didSelectItem = didSelectItem
    }

    public final func updateItems(_ newItems: [ItemType]) {
        self.items = newItems
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            fatalError("Cell type mismatch")
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

