//
//  File.swift
//  Documents
//
//  Created by Astemir Shibzuhov on 28.02.2025.
//

import UIKit
import DesignTokens
import DesignKit

final class DocumentsTableViewAdapter: SimpleTableViewAdapter<DocumentModel, DocumentTableViewCell> {
}

// Доделать
final class DocumentsSkeletonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

final class DocumentsViewController: UIViewController {
    var output: DocumentsViewOutput!
    
    private lazy var documentsEmptyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var documentIconImageView: UIImageView = {
        let imageView = UIImageView(image: .appImages.sfIcons.document.withSize(size: 40, weight: .regular))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var documentsEmptyLabel: UILabel = {
        let label = UILabel()
        label.font = .appFonts.textSemibold
        label.textColor = .appColors.text.primary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Документы не добавлены"
        return label
    }()
    
    private lazy var addDocumentButton: ButtonsContainer = {
        let button = ButtonsContainer().forAutoLayout()
        button.setTitles(primary: "Добавить")
        button.primaryTapHandler { [weak self] in
            self?.output.addDocument()
        }
        return button
    }()
    
    private lazy var tableViewAdapter = DocumentsTableViewAdapter(items: []) { [weak self] document in
        self?.output.openDocument(with: document.id)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().forAutoLayout()
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: DocumentTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = tableViewAdapter
        tableView.dataSource = tableViewAdapter
        return tableView
    }()
    
    private lazy var skeletonView = DocumentsSkeletonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.addFourNullConstraintToSuperView()
        tableView.separatorStyle = .none
        documentsEmptyStackView.addArrangedSubviews([documentIconImageView, documentsEmptyLabel])
        title = "Документы"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    @objc
    private func addAction() {
        output.addDocument()
    }
    
    private func configureForEmpty() {
        view.addSubview(documentsEmptyStackView)
        documentsEmptyStackView.addConstraintToSuperView([.leading(30), .trailing(-30), .centerY(0)], withSafeArea: true)
        view.addSubview(addDocumentButton)
        addDocumentButton.addConstraintToSuperView([.bottom(-20), .leading(0), .trailing(0)], withSafeArea: true)
        self.tableView.isHidden = true
    }
    
    private func setLoading() {
        tableView.isHidden = true
        self.view.addSubview(skeletonView)
        skeletonView.addFourNullConstraintToSuperView(withSafeArea: true)
    }
    
    private func removeSkeleton() {
        skeletonView.removeFromSuperview()
        tableView.isHidden = false
    }
}

extension DocumentsViewController: DocumentsViewInput, ErrorViewInput {
    func setState(state: DocumentsViewState) {
        switch state {
        case .loading:
            setLoading()
        case .loaded(let items):
            if items.isEmpty {
                self.configureForEmpty()
            } else {
                addDocumentButton.removeFromSuperview()
                navigationItem.rightBarButtonItem = .init(image: .appImages.sfIcons.add.withSize(size: 20, weight: .regular), style: .plain, target: self, action: #selector(addAction))
                tableView.isHidden = false
            }
            self.tableViewAdapter.updateItems(items)
            self.tableView.reloadData()
            removeSkeleton()
        case .error:
            tableView.isHidden = true
            showFullScreenError { [weak self] in
                self?.output.refresh()
            }
        }
    }
}
