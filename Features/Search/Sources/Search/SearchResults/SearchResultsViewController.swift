//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit
import DesignKit


final class SearchResultsViewController: CommonViewController {
    var searchViewController: UIViewController!
    var searchHeightConstraint: NSLayoutConstraint!
    var searchBottomConstraint: NSLayoutConstraint!

    var searchView: UIView {
        searchViewController.view
    }
    
    var output: SearchResultsViewOutput!
    private let adapter = SearchResultsAdapter(items: [])
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).forAutoLayout()
        collectionView.delegate = adapter
        collectionView.dataSource = adapter
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.addFourNullConstraintToSuperView(withSafeArea: true)
        configureSearchView()

    }
}

extension SearchResultsViewController: SearchResultsViewInput {
    func updateUI(items: [any SearchResultItem]) {
        adapter.updateItems(items)
        collectionView.reloadData()
    }
    
    
}
