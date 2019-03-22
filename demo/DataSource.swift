//
//  DataSource.swift
//  demo
//
//  Created by Astemir Eleev on 22/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit
import message_view

// MARK: - Data Source that holds the structures data for the demo target, where MessageView is packed into named tuples with style name and executable closure
struct DataSource {
    
    // MARK: - Typealiases
    
    typealias Data = (name: String, data: [(style: String, executable: () -> Void)])
    
    // MARK: - Properties
    
    private let dataSource = [
        (name: "Activity", data: [
            (style: "Default style", executable: {
                MessageView.configure(with: .default)
                MessageView.showActivity(withMessage: "Activity! Default style", dismissAfter: 3.0) }),
            (style: "Extra Light Style", executable : {
                MessageView.configure(with: .extraLight)
                MessageView.showActivity(withMessage: "Activity! Extra Light style", dismissAfter: 3.0) }),
            (style: "Dark style", executable: {
                MessageView.configure(with: .dark)
                MessageView.showActivity(withMessage: "Activity! Dark style", dismissAfter: 3.0) })
            ]),
        (name: "Success", data: [
            (style: "Default style", executable: {
                MessageView.configure(with: .default)
                MessageView.showSuccess(withMessage: "Success! Default style", dismissAfter: 3.0) }),
            (style: "Extra Light Style", executable : {
                MessageView.configure(with: .extraLight)
                MessageView.showSuccess(withMessage: "Success! Extra Light style", dismissAfter: 3.0) }),
            (style: "Dark style", executable: {
                MessageView.configure(with: .dark)
                MessageView.showSuccess(withMessage: "Success! Dark style", dismissAfter: 3.0) })
            ]),
        (name: "Warning", data: [
            (style: "Default style", executable: {
                MessageView.configure(with: .default)
                MessageView.showWarning(withMessage: "Warning! Default style", dismissAfter: 3.0) }),
            (style: "Extra Light Style", executable : {
                MessageView.configure(with: .extraLight)
                MessageView.showWarning(withMessage: "Warning! Extra Light style", dismissAfter: 3.0) }),
            (style: "Dark style", executable: {
                MessageView.configure(with: .dark)
                MessageView.showWarning(withMessage: "Warning! Dark style", dismissAfter: 3.0) })
            ]),
        (name: "Custom", data: [
            (style: "Long running task", executable: {
                MessageView.configure(with: .dark)
                MessageView.showActivity(withMessage: "Initial message")
                
                DispatchQueue.global().async {
                    MessageView.update(message: "Data is about to load...")
                    sleep(3)
                    
                    (0...100).forEach({ index in
                        usleep(50_000)
                        MessageView.update(message: "Loading: \(index)%")
                    })
                    MessageView.update(message: "Completed task!", dismissAfter: 2.5)
                }
            })
            ])
    ]
    
    // MARK: - Subscripts
    
    subscript(index: Int) -> Data {
        return dataSource[index]
    }
    
    func sections() -> Int {
        return dataSource.count
    }
    
    func rows(in section: Int) -> Int {
        return dataSource[section].data.count
    }
    
    // MARK: - Methods
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        let section = dataSource[indexPath.section]
        let source = section.data[indexPath.row]
        
        cell.textLabel?.text = source.style
        
        if section.name == "Custom" {
            cell.detailTextLabel?.text = "Emulates a long running task with message updates"
        } else {
            cell.detailTextLabel?.text = "Automatically disappears after 3.0 seconds"
        }
    }
}
