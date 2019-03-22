//
//  MessageView.swift
//  message-view
//
//  Created by Astemir Eleev on 21/03/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

/// MessageView is HUD component that is intended to be used in cases when success or failure messages and activity progress need to be reported to the user. The usage of the component is quite straingforward:
///
/// - shared instance - yes, singletons are bad, but in some cases they are useful. You will not be able to create broken state, unless you use concurrently will present different MessageViews. This is the preffered and quite convenient way to use this component in the majority of cases.
///
/// The visials can be customized by using the build-in styles [MessageViewBuilder](MessageViewBuilder.swift), or you can create your own presentations and use the `configure` method to change the default appearence.
public final class MessageView: UIView {
    
    // MARK: - Private properties
    
    private var builder: MessageViewBuilder = MessageViewDefaultBuilder() {
        didSet {
            loadingIndicator.transform = builder.loadingIndicatorInitialTransform
            loadingIndicator.color = builder.activityIndicatorColor
            
            messageLabel.font = builder.messageFont
            messageLabel.textColor = builder.messageColor
            
            imageView.transform = builder.loadingIndicatorInitialTransform
            
            blurEffectView?.removeFromSuperview()
            blurEffectView = createVisualEffectView()
            prepareBackground()
        }
    }
    
    private var state: State = .hidden
    private static let shared = MessageView()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = builder.loadingIndicatorInitialTransform
        view.color = builder.activityIndicatorColor
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = builder.messageFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = builder.messageColor
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = builder.successColor
        view.alpha = 0
        view.transform = builder.loadingIndicatorInitialTransform
        return view
    }()
    
    fileprivate lazy var blurEffectView: UIVisualEffectView? = {
        return createVisualEffectView()
    }()
    
    private var defaultWindow: UIWindow?
    
    // MARK: - Initializers
    
    private init(window: UIWindow? = UIApplication.shared.keyWindow) {
        super.init(frame: .zero)
        defaultWindow = window
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Try to use the shared instance instead")
    }
    
    // MARK: - Methods
    
    /// Presents message with an activity indicator view. The intention behind this presentation is to report some long running, indefined task.
    ///
    /// - Parameters:
    ///   - message: is an optioanl `String` message that will be displayed below the activity indicator
    ///   - delay: is a `TimeInterval` parameter that delays the presentation of the component
    ///   - interval: is a `TimeInterval` parameter that will be used to dismiss the component after the specified number of seconds (default is `0.0`, which means that the component needs to be dismissed **manually**)
    public class func showActivity(withMessage message: String? = nil,
                                   afterDelay delay: TimeInterval = 0.25,
                                   dismissAfter interval: TimeInterval = 0.0) {
        State.message.getExecutable(with: message, delay: delay)()
        hideIfDelayed(interval)
    }
    
    /// Presents a success message. The intention behind this presentation is to report that something was successfull or completed.
    ///
    /// - Parameters:
    ///   - message: is an optioanl `String` message that will be displayed below the activity indicator
    ///   - delay: is a `TimeInterval` parameter that delays the presentation of the component
    ///   - interval: is a `TimeInterval` parameter that will be used to dismiss the component after the specified number of seconds (default is `0.0`, which means that the component needs to be dismissed **manually**)
    public class func showSuccess(withMessage message: String? = nil,
                                  afterDelay delay: TimeInterval = 0.25,
                                  dismissAfter interval: TimeInterval = 0.0) {
        State.success.getExecutable(with: message, delay: delay)()
        hideIfDelayed(interval)
    }
    
    /// Presents a warning message. The intention behind this presentation is to report that something wasn't successfull or failed.
    ///
    /// - Parameters:
    ///   - message: is an optioanl `String` message that will be displayed below the activity indicator
    ///   - delay: is a `TimeInterval` parameter that delays the presentation of the component
    ///   - interval: is a `TimeInterval` parameter that will be used to dismiss the component after the specified number of seconds (default is `0.0`, which means that the component needs to be dismissed **manually**)
    public class func showWarning(withMessage message: String? = nil,
                                  afterDelay delay: TimeInterval = 0.25,
                                  dismissAfter interval: TimeInterval = 0.0) {
        State.warning.getExecutable(with: message, delay: delay)()
        hideIfDelayed(interval)
    }
    
    /// Presents a custom image above the message. The intention behing this presentation style is defined by you, the developer.
    ///
    /// - Parameters:
    ///   - image: is a `UIImage` parameter that holds a valid image that will be presented above the text message. The image should be white on transparent background, since the rendering mode is `alwaysTemplate`.
    ///   - color: is a `UIColor` parameter that is used to color the image
    ///   - message: is an optioanl `String` message that will be displayed below the activity indicator
    ///   - delay: is a `TimeInterval` parameter that delays the presentation of the component
    ///   - interval: is a `TimeInterval` parameter that will be used to dismiss the component after the specified number of seconds (default is `0.0`, which means that the component needs to be dismissed **manually**)
    public class func showCustom(image: UIImage,
                                 tintColor color: UIColor = .lightGray,
                                 withMessage message: String? = nil,
                                 afterDelay delay: TimeInterval = 0.25,
                                 dismissAfter interval: TimeInterval = 0.0) {
        State.custom(image, color).getExecutable(with: message, delay: delay)()
        hideIfDelayed(interval)
    }
    
    /// Hides the MessageView immediately
    public class func hide() {
        State.hidden.getExecutable(with: nil, delay: 0.0)()
    }
    
    /// Hides the MessageView after the specified delay
    public class func hide(afterDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            hide()
        })
    }
    
    /// Configuration point. Create your own type that conforms to `MessageViewBuilder` protocol and supply it in order to customize the visuals.
    public class func configure(with builder: MessageViewBuilder) {
        MessageView.shared.builder = builder
    }
    
    /// Configuration point. Create your own type that conforms to `MessageViewBuilder` protocol, wrap it into `MessageViewStyle` enum type and use more convenient configuration style.
    public class func configure(with style: MessageViewStyle) {
        MessageView.shared.builder = style.getBuilder()
    }
    
    /// Updates the text message for the presented `MessageView`. Useful in cases when a single instnace of a `MessageView` needs to be updated without hiding and presenting a new component.
    ///
    /// - Parameters:
    ///   - message: a new `String` message that will be displayed
    ///   - interval: is a `TimeInterval` parameter that will be used to dismiss the component after the specified number of seconds (default is `0.0`, which means that the component needs to be dismissed **manually**)
    public class func update(message: String, dismissAfter interval: TimeInterval = 0.0) {
        DispatchQueue.main.async {
            MessageView.shared.messageLabel.text = message
            hideIfDelayed(interval)
        }
    }
}

// MARK: - Private extension

private extension MessageView {
    
    // MARK: - Methods
    
    private class func hideIfDelayed(_ interval: TimeInterval) {
        guard interval > 0.0 else { return }
        hide(afterDelay: interval)
    }
    
    private func createVisualEffectView() -> UIVisualEffectView? {
        guard let style = builder.backgroundStyle.getBlurStyle() else { return nil }
        let blurEffect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: blurEffect)
        return effectView
    }
    
    private func prepareBackground() {
        switch builder.backgroundStyle {
        case .color(let instance):
            backgroundColor = instance
        case .dark, .light, .extraLight:
            guard let blurEffectView = blurEffectView else { return }
            insertSubview(blurEffectView, belowSubview: self)
            backgroundColor = .clear
            insertSubview(blurEffectView, at: 0)
            blurEffectView.fillInSuperview()
        }
    }
    
    private func setup() {
        func prepareUIComposition() {
            addSubview(loadingIndicator)
            addSubview(messageLabel)
            addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: builder.loadingIndicatorSize),
                imageView.heightAnchor.constraint(equalToConstant: builder.loadingIndicatorSize),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -.smallSpacing),
                
                loadingIndicator.widthAnchor.constraint(equalToConstant: builder.loadingIndicatorSize),
                loadingIndicator.heightAnchor.constraint(equalToConstant: builder.loadingIndicatorSize),
                loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -.smallSpacing),
                
                messageLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: .mediumSpacing),
                messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
                messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing)
                ])
        }
        
        prepareBackground()
        prepareUIComposition()
    }
    
    private func showImage(withMessage message: String? = nil) {
        if superview == nil {
            defaultWindow?.addSubview(self)
            fillInSuperview()
        }
        let data = state.getData(from: builder)
        imageView.image = data.image
        imageView.tintColor = data.color
        
        loadingIndicator.alpha = 0
        messageLabel.text = message
        blurEffectView?.alpha = 0
        
        UIView.animate(withDuration: builder.animationDuration) {
            self.alpha = 1
            self.blurEffectView?.alpha = 1
            self.imageView.alpha = 1
            self.imageView.transform = .identity
        }
    }
    
    private func startAnimating(withMessage message: String? = nil) {
        if superview == nil {
            defaultWindow?.addSubview(self)
            fillInSuperview()
        }
        messageLabel.text = message
        imageView.alpha = 0
        blurEffectView?.alpha = 0
        loadingIndicator.startAnimating()
        loadingIndicator.transform = builder.loadingIndicatorInitialTransform
        loadingIndicator.alpha = 1
        
        UIViewPropertyAnimator(duration: builder.animationDuration, curve: .easeIn) {
            self.alpha = 1
            self.blurEffectView?.alpha = 1
            self.loadingIndicator.transform = .identity
            }.startAnimation()
    }
    
    private func stopAnimating() {
        if defaultWindow != nil {
            let transform = builder.loadingIndicatorInitialTransform
            
            UIView.animate(withDuration: builder.animationDuration, animations: {
                self.loadingIndicator.transform = transform
                self.imageView.transform = transform
            }, completion: { _ in
                self.loadingIndicator.stopAnimating()
                self.messageLabel.text = nil
                
                UIView.animate(withDuration: self.builder.animationDuration, animations: {
                    self.alpha = 0
                    self.blurEffectView?.alpha = 0
                }, completion: { _ in
                    self.removeFromSuperview()
                })
            })
        }
    }
}

// MARK: - Enum type extension
public extension MessageView {
    
    // MARK: - Enum types
    
    /// Private state of the component. Incapsulates the possible cases such as `message` or `success`. Also, it provides conveninet factory methods that produce either executables or data depending on the current state.
    private enum State: Equatable {
        
        // MARK: - Typealisases
        
        typealias Data = (image: UIImage?, color: UIColor?)
        
        // MARK: - Cases
        
        case message
        case hidden
        case success
        case warning
        case custom(UIImage, UIColor)
        
        // MARK: - Methods
        
        func getData(from model: MessageViewBuilder) -> Data {
            let currentBundle = Bundle(for: MessageView.self)

            switch self {
            case .success:
                return (UIImage(named: "checkmark", in: currentBundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate), model.successColor)
            case .warning:
                return (UIImage(named: "warning", in: currentBundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate), model.warningColor)
            case .custom(let image, let color):
                return (image, color)
            default:
                return (nil, nil)
            }
        }
        
        func getExecutable(with message: String?, delay: TimeInterval) -> () -> Void {
            switch self {
            case .success:
                return {
                    MessageView.shared.state = .success
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        if MessageView.shared.state == .success {
                            MessageView.shared.showImage(withMessage: message)
                        }
                    })
                }
            case .message:
                return {
                    MessageView.shared.state = .message
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        if MessageView.shared.state == .message {
                            MessageView.shared.startAnimating(withMessage: message)
                        }
                    })
                }
            case .warning:
                return {
                    MessageView.shared.state = .warning
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        if MessageView.shared.state == .warning {
                            MessageView.shared.showImage(withMessage: message)
                        }
                    })
                }
            case .custom(let image, let tint):
                return {
                    MessageView.shared.state = .custom(image, tint)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        if case .custom = MessageView.shared.state {
                            MessageView.shared.showImage(withMessage: message)
                        }
                    })
                }
            case .hidden:
                return {
                    MessageView.shared.state = .hidden
                    MessageView.shared.stopAnimating()
                }
            }
        }
    }
    
    public enum BackgroundStyle: Equatable {
        
        // MARK: - Cases
        
        case color(UIColor)
        case light
        case extraLight
        case dark
        
        // MARK: - Methods
        
        func getBlurStyle() -> UIBlurEffect.Style? {
            switch self {
            case .light:
                return .light
            case .extraLight:
                return .extraLight
            case .dark:
                return .dark
            default:
                return nil
            }
        }
    }
}
