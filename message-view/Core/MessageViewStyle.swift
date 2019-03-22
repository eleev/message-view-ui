//
//  MessageViewStyle.swift
//  message-view
//
//  Created by Astemir Eleev on 21/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import Foundation

/// A convenience enum wrapper around the built-in `MessageViewBuilder` conforming types
public enum MessageViewStyle {
    case `default`
    case dark
    case extraLight
}

public extension MessageViewStyle {
    func getBuilder() -> MessageViewBuilder {
        switch self {
        case .default:
            return MessageViewDefaultBuilder()
        case .dark:
            return MessageViewDarkBlurBuilder()
        case .extraLight:
            return MessageViewExtraLightBlurBuilder()
        }
    }
}
