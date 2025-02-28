//
//  File.swift
//  Search
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import DesignKit
import UIKit

protocol SearchResultItem {
    
}

struct SearchResultModel: SearchResultItem {
    let title: String
}

final class SearchResultsAdapter: CollectionViewAdapter<SearchResultItem, SearchResultCell> {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 60, height: 60)
    }
}
