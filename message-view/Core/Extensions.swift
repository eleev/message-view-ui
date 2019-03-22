//
//  Extensions.swift
//  message-view
//
//  Created by Astemir Eleev on 21/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

internal extension CGFloat {
    static let smallSpacing: CGFloat    = 8
    static let mediumSpacing: CGFloat   = 16
    static let largeSpacing: CGFloat    = 64
}

internal extension UIView {
    
    @discardableResult
    func fillInSuperview(insets: UIEdgeInsets = .zero, isActive: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = self.superview else { return [NSLayoutConstraint]() }
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints += [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right)
        ]
        if isActive { NSLayoutConstraint.activate(constraints) }
        
        return constraints
    }
}
