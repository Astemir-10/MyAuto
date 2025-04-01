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
    
    var mainCarInfoViewController: UIViewController!
    var mainCarInfoView: UIView {
        mainCarInfoViewController.view
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
        scrollView.addPullToRefresh { [weak self] in
            DispatchQueue.main.async {
                self?.output.refreshAll()
            }
        }
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .appColors.ui.main
        self.addChildVCSimple(petrolWidget)
        self.addChildVCSimple(weatherWidget)
        self.addChildVCSimple(mainCarInfoViewController)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        self.view.addSubview(scrollView)
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        scrollView.addConstraintToSuperView([.leading(0),
                                             .bottom(0),
                                             .top(0),
                                             .trailing(0)],
                                            withSafeArea: true)
        scrollView.addSubview(contentStackView)
        contentStackView.addConstraintToSuperView([.leading(0), .bottom(0), .top(0), .trailing(0)])
        scrollView.showsVerticalScrollIndicator = false
        
        
        contentStackView.addArrangedSubviews(makeWidgetWithHeader(header: nil, view: mainCarInfoView),
                                             makeWidgetWithHeader(header: "Бензин", view: petrolWidgetView, rightViewItem: ("Еще", {
            print("OKOKOKO")
        })),
                                             makeWidgetWithHeader(header: nil, view: weatherWidgetView)
                                             )
        mainCarInfoView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).activated()
        petrolWidgetView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).activated()
        contentStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).activated()
        contentStackView.spacing = 20
    }
    
    private func makeWidgetWithHeader(header: String?, subtitle: String? = nil, view: UIView, rightViewItem: (String, () -> ())? = nil) -> UIView {
        let stackView = UIStackView()
        let headerRightStackView = UIStackView()
        headerRightStackView.axis = .horizontal
        stackView.axis = .vertical
        let headerView = HeaderView()
        headerView.configure { configuration in
            configuration.edgeInsets = .init(top: 12, left: 0, bottom: 12, right: 0)
            configuration.spacing = 8
        }
        headerRightStackView.addArrangedSubview(headerView)
        
        
        if let rightViewItem {
            let button = Button()
            
            button.setSize(.medium)
            button.primaryText = rightViewItem.0
            button.addAction(.init(handler: { _ in
                rightViewItem.1()
            }), for: .touchUpInside)
            headerRightStackView.addArrangedSubview(button)
            button.configure { config in
                config.backgroundColor = .clear
                config.primaryTextColor = .appColors.text.blue
                config.primaryFont = .appFonts.secondaryButton
                config.needShadow = false
            }
            headerRightStackView.distribution = .equalSpacing
        }
        
        
        if let header, let subtitle {
            headerView.set(title: header, subtitle: subtitle)
            stackView.addArrangedSubviews([headerRightStackView])
            headerRightStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -32).activated()
        } else if let header {
            headerView.set(title: header)
            stackView.addArrangedSubviews([headerRightStackView])
            headerRightStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -32).activated()
        }
        
        stackView.addArrangedSubviews([view])
        view.widthAnchor.constraint(equalTo: stackView.widthAnchor).activated()
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }
}

extension MainViewController: MainViewInput, LoaderViewInput {
    func endRefresh() {
        scrollView.endRefreshing()
    }
    

    
    func setLoading(isLoading: Bool) {
//        if isLoading {
//            showLoader()
//        } else {
//            hideLoader()
//        }
    }
  
}
