//
//  ViewController.swift
//  demo
//
//  Created by Astemir Eleev on 21/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit
import message_view

class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = delegate
            tableView.dataSource = dataSource
        }
    }
    
    // MARK: - Properties
    
    private let source = DataSource()
    
    // MARK: - Lazy properties
    
    private lazy var delegate: DemoTableViewDelegate = {
       return DemoTableViewDelegate(dataSource: source)
    }()
    private lazy var dataSource: DemoTalbeViewDataSoruce = {
        return DemoTalbeViewDataSoruce(dataSource: source)
    }()
}
