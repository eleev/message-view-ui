//
//  DemoTalbeViewDataSoruce.swift
//  demo
//
//  Created by Astemir Eleev on 22/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

/// MARK: - A custom UITableViewDataSource conforming type
class DemoTalbeViewDataSoruce: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    private let dataSource: DataSource
    private let tableViewIdentifier = "Cell"
    
    // MARK: - Initializers
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: - Mehtods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier, for: indexPath)
        dataSource.configure(cell: cell, for: indexPath)
        return cell
    }
}
