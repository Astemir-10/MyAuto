//
//  File.swift
//  Calculator
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import UIKit
import DesignKit
import DesignTokens
import Extensions

enum ExpenseType: String, CaseIterable {
    case petrol, service, wash, insurance, taxes, parking, fines
    
    var icon: UIImage {
        switch self {
        case .petrol:
            UIImage.emojiToImage(emoji: "⛽", size: 32)
        case .service:
            UIImage.emojiToImage(emoji: "🛠️", size: 32)
        case .wash:
            UIImage.emojiToImage(emoji: "🚿", size: 32)
        case .insurance:
            UIImage.emojiToImage(emoji: "🛡️", size: 32)
        case .taxes:
            UIImage.emojiToImage(emoji: "📜", size: 32)
        case .parking:
            UIImage.emojiToImage(emoji: "🅿️", size: 23)
        case .fines:
            UIImage.emojiToImage(emoji: "💸", size: 32)
        }
    }
    
    var title: String {
        switch self {
        case .petrol:
            "заправка"
        case .service:
            "Автосервис"
        case .wash:
            "Мойка"
        case .insurance:
            "Страховка"
        case .taxes:
            "Налоги"
        case .parking:
            "Парковка"
        case .fines:
            "Штрафы"
        }
    }
}

protocol ExpenseModelProtocol {
    var id: String { get }
    var date: Date { get }
    var sum: Double { get }
    var type: ExpenseType { get }
    var description: String? { get }
}

struct PetrolExpense: ExpenseModelProtocol {
    struct PetrolStation: Codable, ConvertibleToDictionary {
        let name: String
        let cityName: String
        let petrolTypes: [PetrolTypeItem]
        let longitude: Double
        let latitude: Double
    }
    
    struct PetrolTypeItem: Codable {
        let petrolType: PetrolType
        let priceOnLiter: Double
    }
    
    enum PetrolType: String, Codable {
        case ai92, ai95, ai100, gas, disel, electrol
        
        var titel: String {
            switch self {
            case .ai92:
                "АИ-92"
            case .ai95:
                "АИ-95"
            case .ai100:
                "АИ-100"
            case .gas:
                "СУГ"
            case .disel:
                "ДЕ"
            case .electrol:
                "Эл"
            }
        }
    }
    
    var id: String
    var date: Date
    var sum: Double
    var type: ExpenseType
    var description: String?
    let liters: Double
    let petrolStation: PetrolStation
    
    init(id: String, date: Date, sum: Double, type: ExpenseType, description: String?, liters: Double, petrolStation: [String: Any]) {
        self.id = id
        self.date = date
        self.sum = sum
        self.type = type
        self.description = description
        self.liters = liters
        self.petrolStation = try! .init(from: petrolStation)
    }
}

struct AutoserviceExpense: ExpenseModelProtocol {
    enum ServiceType: String, CaseIterable, Codable {
        case oilChange // Замена масла
        case filters // Замена фильтров
        case tires  // Шиномонтаж
        case brakeSystem // Ремонт тормозной системы колодки
        case engineDiagnostics // Диагностика двигателя
        case batteryService // Замена/зарядка аккумулятора
        case suspension // Ремонт подвески
        case airConditioning // Заправка кондиционера
        case detailing  // Детейлинг
        case painting  // Покраска
        case glassRepair // Ремонт/замена стекол
        case electronics  // Ремонт автоэлектрики
        case transmission  // Ремонт КПП
        case exhaustSystem  // Ремонт выхлопной системы
        case carCare // Полировка, химчистка салона
    }
    
    struct Srevice: Codable, ConvertibleToDictionary {
        let price: Double?
        let type: ServiceType
    }
    
    var id: String
    var date: Date
    var sum: Double
    var type: ExpenseType
    var description: String?
    var services: [Srevice]
    
    init(id: String, date: Date, sum: Double, type: ExpenseType, description: String? = nil, service: [[String: Any]]) {
        self.id = id
        self.date = date
        self.sum = sum
        self.type = type
        self.description = description
        self.services = service.map({ try! Srevice.init(from: $0) })
    }
    
}

struct CommonExpense: ExpenseModelProtocol {
    var id: String
    
    var date: Date
    
    var sum: Double
    
    var type: ExpenseType
    
    var description: String?
}


final class ExpensesTableViewAdapter: TableViewAdapter {
    
}


final class ExpensesViewController: CommonViewController {
    var output: ExpensesViewOutput!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped).forAutoLayout()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear 
        return tableView
    }()
    
    private lazy var tableViewAdapter = ExpensesTableViewAdapter(tableView: tableView) { section, index in
        print(section, index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.addSubview(tableView)
        tableView.addConstraintToSuperView([.top(8), .bottom(-8), .leading(8), .trailing(-8)], withSafeArea: true)
        self.title = "Расходы"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        output.setup()
        tableView.estimatedSectionHeaderHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.reload()
    }
    
    @objc
    private func addAction() {
        output.addExpense()
    }
    
    @objc
    private func analyticsAction() {
        output.analyticsExpense()
    }
}

extension ExpensesViewController: ExpensesViewInput {
    func setState(state: ExpensesScreenState) {
        switch state {
        case .loading:
            break
        case .loaded(let items):
            var sections = [TableViewSection]()
            
            sections.append(TableViewSection(headerType: nil, model: nil, rows: [.init(cellType: ExpenseTypesTableViewCell.self, model: ExpenseTypesCellModel(didSelectItem: { [weak self] type in
                self?.output.addExpense(type: type)
            }), deleteAction: nil)]))
            
            sections.append(.init(headerType: nil, model: nil, rows: [
                .init(cellType: ExpenseFiltersCell.self, model: ExpenseFiltersModel(filters: [
                    ExpenseFilterModel(filter: .all, isSelected: output.selectedFilter() == .all),
                    ExpenseFilterModel(filter: .today, isSelected: output.selectedFilter() == .today),
                    ExpenseFilterModel(filter: .yesterday, isSelected: output.selectedFilter() == .yesterday),
                    ExpenseFilterModel(filter: .week, isSelected: output.selectedFilter() == .week),
                    ExpenseFilterModel(filter: .month, isSelected: output.selectedFilter() == .month),
                    ExpenseFilterModel(filter: .year, isSelected: output.selectedFilter() == .year),
                ], didSelectAction: { [weak self] filter in
                    self?.output.setSelectedFilter(filter: filter)
                }), deleteAction: nil)
            ]))
            
            var fullSum = 0.0
            items.forEach({ fullSum += $0.sum })
            
            sections.append(.init(headerType: nil, model: nil, rows: [
                .init(cellType: TotalExpensesCell.self, model: TotalExpensesModel(fullSum: fullSum, startDate: output.getStartDate(), endDate: output.getEndDate(), filter: output.selectedFilter(), analyticAction: { [weak self] in
                    self?.output.analyticsExpense()
                }), deleteAction: nil)
            ]))
            
            groupDatesByDay(items).forEach({
                sections.append(mapToSection(items: $0))
            })
            
            self.tableViewAdapter.updateSections(sections)
            
            self.tableViewAdapter.afterDelete { [weak self] in
                guard let amount = self?.output.getTotalAmount(), let filter = self?.output.selectedFilter() else { return }
                self?.tableViewAdapter.updateCell(indexPath: .init(row: 0, section: 1), newModel: .init(cellType: TotalExpensesCell.self, model: TotalExpensesModel(fullSum: amount, startDate: self?.output.getStartDate(), endDate: self?.output.getEndDate(), filter: filter, analyticAction: { [weak self] in
                    self?.output.analyticsExpense()
                }), deleteAction: nil))
            }
            
        case .error:
            break
        }
    }
    
    private func mapToSection(items: [ExpenseModelProtocol]) -> TableViewSection {
        return .init(headerType: ExpenseHeaderView.self, model: ExpenseHeaderModel(date: items.first!.date), rows: items.map({ AnyTableRow(cellType: ExpensesTableViewCell.self, model: $0, deleteAction: { [weak self] model in
            guard let model = model as? ExpenseModelProtocol else { return }
            self?.output.remove(item: model)
        }) }))
    }
    
    private func groupDatesByDay(_ dates: [ExpenseModelProtocol]) -> [[ExpenseModelProtocol]] {
        let dateFormatter = DateFormatter.simpleFormatter
        
        // Группируем в словарь [String: [Date]]
        let groupedDict = Dictionary(grouping: dates) { expense in
            dateFormatter.string(from: expense.date)
        }
        
        // Преобразуем словарь в массив массивов, отсортированный по дате
        let sortedGroups = groupedDict.values.sorted { group1, group2 in
            guard let firstDate1 = group1.first, let firstDate2 = group2.first else { return false }
            return firstDate1.date > firstDate2.date
        }
        
        return sortedGroups
    }
}

