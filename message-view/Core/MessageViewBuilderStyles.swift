//
//  MessageViewBuilderStyles.swift
//  message-view
//
//  Created by Astemir Eleev on 21/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

public struct MessageViewDefaultBuilder: MessageViewBuilder {
    public var activityIndicatorColor: UIColor                          = .init(red: 0.0, green: 99 / 256, blue: 251 / 256, alpha: 1.0)
    public var messageColor: UIColor                                    = .init(red: 71 / 256, green: 68 / 256, blue: 69 / 256, alpha: 1.0)
    public var messageFont: UIFont                                      = UIFont.systemFont(ofSize: 16)
    public var animationDuration: TimeInterval                          = 0.35
    public var loadingIndicatorSize: CGFloat                            = 45
    public var loadingIndicatorInitialTransform: CGAffineTransform      = CGAffineTransform(scaleX: 0.01, y: 0.01)
    public var successColor: UIColor                                    = .init(red: 0.0, green: 134 / 256, blue: 245 / 256, alpha: 1.0)
    public var warningColor: UIColor                                    = .init(red: 245 / 256, green: 0.0, blue: 0.0, alpha: 1.0)
    public var backgroundStyle: MessageView.BackgroundStyle             = .color(UIColor.white.withAlphaComponent(0.85))
}

public struct MessageViewDarkBlurBuilder: MessageViewBuilder {
    public var activityIndicatorColor: UIColor                          = .init(red: 35 / 256, green: 158 / 256, blue: 242 / 256, alpha: 1.0)
    public var messageColor: UIColor                                    = .init(red: 224 / 256, green: 200 / 256, blue: 220 / 256, alpha: 1.0)
    public var messageFont: UIFont                                      = UIFont.systemFont(ofSize: 16)
    public var animationDuration: TimeInterval                          = 0.35
    public var loadingIndicatorSize: CGFloat                            = 45
    public var loadingIndicatorInitialTransform: CGAffineTransform      = CGAffineTransform(scaleX: 0.01, y: 0.01)
    public var successColor: UIColor                                    = .init(red: 0.0, green: 134 / 256, blue: 245 / 256, alpha: 1.0)
    public var warningColor: UIColor                                    = .init(red: 245 / 256, green: 0.0, blue: 0.0, alpha: 1.0)
    public var backgroundStyle: MessageView.BackgroundStyle             = .dark
}

public struct MessageViewExtraLightBlurBuilder: MessageViewBuilder {
    public var activityIndicatorColor: UIColor                          = .init(red: 128 / 256, green: 128 / 256, blue: 128 / 256, alpha: 1.0)
    public var messageColor: UIColor                                    = .init(red: 64 / 256, green: 64 / 256, blue: 64 / 256, alpha: 1.0)
    public var messageFont: UIFont                                      = UIFont.systemFont(ofSize: 16)
    public var animationDuration: TimeInterval                          = 0.35
    public var loadingIndicatorSize: CGFloat                            = 45
    public var loadingIndicatorInitialTransform: CGAffineTransform      = CGAffineTransform(scaleX: 0.01, y: 0.01)
    public var successColor: UIColor                                    = .init(red: 0.0, green: 134 / 256, blue: 245 / 256, alpha: 1.0)
    public var warningColor: UIColor                                    = .init(red: 245 / 256, green: 0.0, blue: 0.0, alpha: 1.0)
    public var backgroundStyle: MessageView.BackgroundStyle             = .extraLight
}
