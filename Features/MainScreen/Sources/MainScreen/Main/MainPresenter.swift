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
    func endRefresh()
}

protocol MainViewOutput {
    func viewDidLoad()
    func refreshAll()
}

final class MainPresenter {
    weak var view: MainViewInput?
    private let router: MainRouterInput
    private var cancaellables = Set<AnyCancellable>()
    
    private var widgets = [AppWidgets.WidgetType.petrol, .weather]
    private var refreshWidgets = [AppWidgets.WidgetType.petrol, .weather]
    var petrolWidgetModuleInput: WidgetInput?
    var weatherWidgetModuleInput: WidgetInput?
    
    init(view: MainViewInput, router: MainRouterInput) {
        self.view = view
        self.router = router
    }
}

extension MainPresenter: MainViewOutput {
    func viewDidLoad() {
        self.view?.setLoading(isLoading: true)
    }
    
    func refreshAll() {
        petrolWidgetModuleInput?.refresh()
        weatherWidgetModuleInput?.refresh()
    }
}

extension MainPresenter: PetrolWidgetModuleOutput {
    func endRefresh(widget: WidgetType) {
        refreshWidgets.append(widget)
        if refreshWidgets.contains(.petrol), refreshWidgets.contains(.weather) {
            view?.endRefresh()
            refreshWidgets.removeAll()
        }
    }
    
    func didTapLocation(item: PetrolWidgetInfoModel) {
        
    }
    
    func didTapPetrol(item: PetrolWidgetInfoModel) {
        
    }
    
    func widgetIsLoaded(widgetType: AppWidgets.WidgetType) {
        widgets.removeAll(where: { $0.rawValue == widgetType.rawValue })
        
        if widgets.isEmpty {
            self.view?.setLoading(isLoading: false)
            view?.endRefresh()
        }
    }
}
