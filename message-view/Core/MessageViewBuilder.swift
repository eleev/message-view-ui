//
//  MessageViewBuilder.swift
//  message-view
//
//  Created by Astemir Eleev on 21/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

/// Builder protocol that decomposes the data needed to configure the `MessageView` class.
public protocol MessageViewBuilder {
    var activityIndicatorColor:             UIColor { get }
    var messageColor:                       UIColor { get }
    var messageFont:                        UIFont { get }
    var animationDuration:                  TimeInterval { get }
    var loadingIndicatorSize:               CGFloat { get }
    var loadingIndicatorInitialTransform:   CGAffineTransform { get }
    var successColor:                       UIColor { get }
    var warningColor:                       UIColor { get }
    var backgroundStyle:                    MessageView.BackgroundStyle { get }
}
