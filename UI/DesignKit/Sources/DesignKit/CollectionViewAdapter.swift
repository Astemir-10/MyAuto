//
//  CollectionViewAdapter.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit

public protocol SimpleConfigurableCell {
    associatedtype ItemType
    func configure(with item: ItemType)
}

open class CollectionViewAdapter<ItemType, CellType: UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout where CellType: SimpleConfigurableCell, CellType.ItemType == ItemType {
    
    private var items: [ItemType]
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

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            fatalError("Cell type mismatch")
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(items[indexPath.row])
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 16, height: 50)
    }
}

