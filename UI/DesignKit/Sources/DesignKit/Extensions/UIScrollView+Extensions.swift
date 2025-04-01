//
//  File.swift
//  DesignKit
//
//  Created by Astemir Shibzuhov on 14.03.2025.
//

import UIKit

public extension UIScrollView {
    private struct AssociatedKeys {
        static var refreshControl: UInt8 = 88
        static var refreshControlAction: UInt8 = 82
    }

    var pullToRefresh: UIRefreshControl? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshControl) as? UIRefreshControl
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshControl, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addPullToRefresh(action: @escaping () -> Void) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.insertSubview(refreshControl, at: 0)
        self.pullToRefresh = refreshControl

        objc_setAssociatedObject(self, &AssociatedKeys.refreshControlAction, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    func endRefreshing() {
        pullToRefresh?.endRefreshing()
    }

    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        if let acrion = objc_getAssociatedObject(self, &AssociatedKeys.refreshControlAction) as? () -> () {
            acrion()
        }
    }
}

