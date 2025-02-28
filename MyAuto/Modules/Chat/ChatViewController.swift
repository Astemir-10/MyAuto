//
//  ChatViewController.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 17.08.2024.
//

import UIKit
import DesignKit

// РАБОТАЕТ tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
//final class ChatViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource {
//    
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView().forAutoLayout()
//        tableView.delegate = self
//        tableView.dataSource = self
//        return tableView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(tableView)
//        tableView.addConstraintToSuperView([.top(0), .leading(0), .trailing(0), .bottom(0)], withSafeArea: true)
//        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        var congiguration = cell.defaultContentConfiguration()
//        congiguration.text = "Hello"
//        
//        cell.contentConfiguration = congiguration
//        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//}
