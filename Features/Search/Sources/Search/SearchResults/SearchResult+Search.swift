//
//  File.swift
//  Search
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import UIKit

extension SearchResultsViewController {
    private var collapsedSearchViewHeight: CGFloat {
        176
    }
    
    private var expandedSearchViewheight: CGFloat {
        view.frame.height - 70
    }
    
    func configureSearchView() {
        self.addChildVCWithoutConstraints(searchViewController)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.addConstraintToSuperView([.leading(0), .trailing(0)])
        searchHeightConstraint = searchView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -70).activated()
        print(view.frame.height)
        searchBottomConstraint = searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: expandedSearchViewheight - collapsedSearchViewHeight).activated()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        searchViewController.view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .began:
            // Сохраните начальное положение
            break
        case .changed:
            // Измените высоту searchViewController в зависимости от перемещения
            let collapsed = expandedSearchViewheight - collapsedSearchViewHeight
            let extended: CGFloat = 0
            let newBottomConstant = min(collapsed, max(extended, searchBottomConstraint.constant + translation.y))
            searchBottomConstraint.constant = newBottomConstant
            gesture.setTranslation(.zero, in: view)

        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view).y
            let dragToTop = velocity < 0
            let shouldExpand: Bool

            if dragToTop {
                if abs(velocity) >= 200 || searchViewController.view.frame.height > collapsedSearchViewHeight + 120 {
                    shouldExpand = true
                } else {
                    shouldExpand = false

                }
            } else {
                if abs(velocity) >= 180 || searchViewController.view.frame.height < view.frame.height / 2 + 200 {
                    shouldExpand = false
                } else {
                    shouldExpand = true
                }
            }
            let path = shouldExpand ? self.searchBottomConstraint.constant : expandedSearchViewheight - self.searchBottomConstraint.constant
            let animationSpeed: CGFloat = max(abs(velocity), 1200)
            let animationDuration = path / animationSpeed

            if !dragToTop {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.searchBottomConstraint.constant = self.expandedSearchViewheight - self.collapsedSearchViewHeight
//                    self.navigationController?.navigationBar.alpha = 1
                    self.view.layoutIfNeeded()
                }) { [weak self] _ in
                    self?.view.endEditing(true)
                }
            } else {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.searchBottomConstraint.constant = 0
//                    self.navigationController?.navigationBar.alpha = 0
                    self.view.layoutIfNeeded()
                })

            }

        default:
            break
        }
    }
    
    
    // MARK: Delegate
    public func setExpandedState() {
        guard searchBottomConstraint.constant != 0 else { return }

        let animationSpeed: CGFloat = 1200
        let animationDuration = self.searchBottomConstraint.constant / animationSpeed

        UIView.animate(withDuration: animationDuration) {
            self.searchBottomConstraint.constant = 0
//            self.navigationController?.navigationBar.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}
