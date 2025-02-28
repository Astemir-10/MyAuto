//
//  File.swift
//  MainScreen
//
//  Created by Astemir Shibzuhov on 02.11.2024.
//

import AppServices
import AppWidgets
import Combine

protocol MainViewInput: AnyObject {
    func setLoading(isLoading: Bool)
}

protocol MainViewOutput {
    func viewDidLoad()
}

final class MainPresenter {
    weak var view: MainViewInput?
    private let router: MainRouterInput
    private var cancaellables = Set<AnyCancellable>()
    private var widgets = [AppWidgets.WidgetType.petrol, .weather]
    
    init(view: MainViewInput, router: MainRouterInput) {
        self.view = view
        self.router = router
    }
}

extension MainPresenter: MainViewOutput {
    func viewDidLoad() {
        self.view?.setLoading(isLoading: true)
    }
    
}

extension MainPresenter: PetrolWidgetModuleOutput {
    
    
    func didTapLocation(item: PetrolWidgetInfoModel) {
        
    }
    
    func didTapPetrol(item: PetrolWidgetInfoModel) {
        
    }
    
    func widgetIsLoaded(widgetType: AppWidgets.WidgetType) {
        widgets.removeAll(where: { $0.rawValue == widgetType.rawValue })
        
        if widgets.isEmpty {
            self.view?.setLoading(isLoading: false)
        }
    }
}
