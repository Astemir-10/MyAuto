//
//  LifeCycleObserver.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 15.08.2024.
//

import Foundation

public protocol LifeCycleObserver {
    func viewDidLoad()
}

public extension LifeCycleObserver {
    func viewDidLoad() {}
}
