//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 30.10.2024.
//

import UIKit

extension MainViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            let itemSize: NSCollectionLayoutSize
            let item: NSCollectionLayoutItem
            
            let groupSize: NSCollectionLayoutSize
            let group: NSCollectionLayoutGroup
            
            let section: NSCollectionLayoutSection
            
            let snapshot = self.dataSource.snapshot()
            
            let sectionIdentifier = snapshot.sectionIdentifiers[sectionIndex]

            switch sectionIdentifier {
                
            case .carWidget:
                itemSize = .init(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(200))
                item = .init(layoutSize: itemSize)
                item.contentInsets = .init(top: 8,
                                           leading: 8,
                                           bottom: 8,
                                           trailing: 8)
                
                groupSize = .init(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .estimated(200))
                group = .vertical(layoutSize: groupSize, subitems: [item])
                section = .init(group: group)
            case .categories:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                group.interItemSpacing = .fixed(10)
                
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(40)
                            ),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top)
                    ]
            case .petrolWidget, .weatherWidget:
                itemSize = .init(widthDimension: .fractionalWidth(1.0),
                                 heightDimension: .estimated(200))
                item = .init(layoutSize: itemSize)
                item.contentInsets = .init(top: 8,
                                           leading: 8,
                                           bottom: 8,
                                           trailing: 8)
                
                groupSize = .init(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .estimated(200))
                group = .vertical(layoutSize: groupSize, subitems: [item])
                section = .init(group: group)

                section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(40)
                            ),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top)
                    ]
            case .popular:
                return nil
            case .recommendation:
                return nil
            case .recent:
                return nil
            case .tuning:
                return nil
            case .tips:
                return nil
            }
            return section
        }
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            
            let snapshot = self.dataSource.snapshot()
            
            let sectionIdentifier = snapshot.sectionIdentifiers[indexPath.section]
            
            switch sectionIdentifier {
                
            case .carWidget:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCarWidgetCell.identifier, for: indexPath) as! MainCarWidgetCell
                cell.setContentView(view: mainCarInfoView)
                return cell
            case .categories:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.contentView.backgroundColor = .systemBlue
                cell.contentView.layer.cornerRadius = 8
                return cell

            case .petrolWidget, .weatherWidget:
                if sectionIdentifier == .weatherWidget {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainWidgetCell.identifier, for: indexPath) as? MainWidgetCell
                    
                    cell?.setContentView(view: self.weatherWidgetView)
                    collectionView.collectionViewLayout.invalidateLayout()
                    return cell

                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainWidgetCell.identifier, for: indexPath) as? MainWidgetCell
                
                cell?.setContentView(view: self.petrolWidgetView)
                collectionView.collectionViewLayout.invalidateLayout()
                return cell
                
            case .popular:
                return UICollectionViewCell()
            case .recommendation:
                return UICollectionViewCell()
            case .recent:
                return UICollectionViewCell()
            case .tuning:
                return UICollectionViewCell()
            case .tips:
                return UICollectionViewCell()
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let snapshot = dataSource.snapshot()
            
            let sectionIdentifier = snapshot.sectionIdentifiers[indexPath.section]
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainSectionHeader", for: indexPath) as? MainSectionHeader
            
            switch sectionIdentifier {
            case .carWidget:
                headerView?.setTitle(title: "Автомобиль")
            case .categories:
                break
            case .petrolWidget:
                headerView?.setTitle(title: "Бензин")
            case .weatherWidget:
                headerView?.setTitle(title: "Погода")
            case .popular:
                break
            case .recommendation:
                break
            case .recent:
                break
            case .tuning:
                break
            case .tips:
                break
            }
        

            return headerView
        }
        return dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.carWidget, .petrolWidget, .weatherWidget])
        
        snapshot.appendItems([.carWidget(.init())], toSection: .carWidget)
        snapshot.appendItems([.widget(.petrol)], toSection: .petrolWidget)
        snapshot.appendItems([.widget(.weather)], toSection: .weatherWidget)
                
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}
