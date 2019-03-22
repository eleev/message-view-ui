//
//  DemoTableViewDelegate.swift
//  demo
//
//  Created by Astemir Eleev on 22/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

/// MARK: - A custom UITableViewDelegate conforming type
class DemoTableViewDelegate: NSObject, UITableViewDelegate {
    
    // MARK: - Properties
    
    private let dataSource: DataSource
    private let headerFont = UIFont.systemFont(ofSize: 21, weight: .bold)
    private let headerTextColor: UIColor = .darkGray
    
    // MARK: - Initializers
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerFooterView = view as? UITableViewHeaderFooterView
        headerFooterView?.backgroundView?.backgroundColor = .clear
        headerFooterView?.textLabel?.textColor = headerTextColor
        headerFooterView?.textLabel?.font = headerFont
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let function = dataSource[indexPath.section].data[indexPath.row]
        function.executable()
    }
}
