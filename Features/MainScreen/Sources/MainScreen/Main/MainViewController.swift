import UIKit
import DesignKit
import AppWidgets

enum Section {
    case carWidget
    case categories
    case petrolWidget
    case weatherWidget
    case popular
    case recommendation //
    case recent
    case tuning
    case tips // советы статьи по уходу за автомобилем зная марку и модель
}

enum Item: Hashable {
    case carWidget(CarWidgetItem)
    case widget(WidgetType)
    case categories(MainItem)
    case popular(Popular)
    
    enum WidgetType {
        case weather, petrol
    }
}

struct Popular: Hashable {
    let title: String
}

struct MainItem: Hashable {
    let id = UUID()  // Уникальный идентификатор
    let title: String
}

struct CarWidgetItem: Hashable {
    let id = UUID()
}


public final class MainViewController: CommonViewController {

    // MARK: CollectionView
    private(set) lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).forAutoLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(MainCarWidgetCell.self, forCellWithReuseIdentifier: MainCarWidgetCell.identifier)
        collectionView.register(MainWidgetCell.self, forCellWithReuseIdentifier: MainWidgetCell.identifier)
        collectionView.register(MainSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainSectionHeader")
        return collectionView
    }()
    
    private(set) lazy var dataSource = createDataSource()
    
    // MARK: Widgets
    var petrolWidget: UIViewController!
    var petrolWidgetView: UIView {
        petrolWidget.view
    }
    
    var weatherWidget: UIViewController!
    var weatherWidgetView: UIView {
        weatherWidget.view
    }
    
    // MARK: UIScrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView().forAutoLayout()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView().forAutoLayout()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
        
    var output: MainViewOutput!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .appColors.ui.main
//        view.addSubview(collectionView)
//        collectionView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0), .bottom(0)], withSafeArea: true)
//        applyInitialSnapshot()
        self.addChildVCSimple(petrolWidget)
        self.addChildVCSimple(weatherWidget)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        self.view.addSubview(scrollView)
        scrollView.addConstraintToSuperView([.leading(8),
                                             .bottom(-8),
                                             .top(8),
                                             .trailing(-8)],
                                            withSafeArea: true)
        scrollView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.leading(0), .bottom(0), .top(0), .trailing(0)])
        contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).activated()
        
        contentStackView.addArrangedSubviews(makeWidgetWithHeader(header: "Бензин", view: petrolWidgetView),
                                             makeWidgetWithHeader(header: "Погода", view: weatherWidgetView))
        

    }
    
    private func makeWidgetWithHeader(header: String, view: UIView) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        let headerView = HeaderView()
        headerView.configure { configuration in
            configuration.edgeInsets = .init(top: 12, left: 0, bottom: 12, right: 0)
        }
        headerView.set(title: header)
        stackView.addArrangedSubviews([headerView, view])
        return stackView
    }
    
}

extension MainViewController: MainViewInput, LoaderViewInput {
    func setLoading(isLoading: Bool) {
        if isLoading {
            showLoader()
        } else {
            hideLoader()
        }
    }
  
}
