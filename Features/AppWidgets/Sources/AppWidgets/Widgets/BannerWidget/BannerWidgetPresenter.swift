//
//  BannerWidgetPresenter.swift
//  AppWidgets
//
//  Created by Astemir Shibzuhov on 04.11.2024.
//

import Foundation

protocol BannerWidgetViewInput: WidgetViewInput {
    
}

protocol BannerWidgetViewOutput {
    func viewDidLoad()
}

public enum BannerWidgetState {
    case tip(String)
    case warning(String)
}

final class BannerWidgetPresenter {
    
    weak var view: BannerWidgetViewInput?
    private let state: BannerWidgetState
    
    init(state: BannerWidgetState, view: BannerWidgetViewInput) {
        self.view = view
        self.state = state
    }
    
}

extension BannerWidgetPresenter: BannerWidgetViewOutput {
    func viewDidLoad() {
        self.view?.setState(.loaded(data: state))
    }
}
