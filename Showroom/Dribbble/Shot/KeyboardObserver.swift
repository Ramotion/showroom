//
//  KeyboardObserver.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 03/08/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import Foundation
import RxSwift

public final class KeyboardObserver {
    
    public struct UserInfo {
        
        private let userInfo: [AnyHashable: Any]
        
        public var frameBegin: CGRect {
            return (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        }
        
        public var frameEnd: CGRect {
            return (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        }
        
        public var duration: Double {
            return (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        }
        
        public var curve: UIViewAnimationOptions {
            guard let value = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int else { return [] }
            
            switch value {
            case UIViewAnimationCurve.easeIn.rawValue:
                return .curveEaseIn
            case UIViewAnimationCurve.easeInOut.rawValue:
                return .curveEaseInOut
            case UIViewAnimationCurve.easeOut.rawValue:
                return .curveEaseOut
            case UIViewAnimationCurve.linear.rawValue:
                return .curveLinear
            default:
                return []
            }
        }
        
        public var isLocal: Bool {
            return (userInfo[UIKeyboardIsLocalUserInfoKey] as? Bool) ?? false
        }
        
        public init(userInfo: [AnyHashable: Any]) {
            self.userInfo = userInfo
        }
        
        /// Returns a distance from keyboard's frameEnd top edge to view's bottom edge
        public func frameEndBottomInset(in view: UIView) -> CGFloat {
            let frameInView = view.convert(frameEnd, from: nil)
            return max(0, view.frame.maxY - frameInView.minY)
        }
        
    }
    
    private let notificationCenter = NotificationCenter.default
    
    public private(set) var userInfo: UserInfo?
    
    // MARK: Instantiating
    
    public static let shared = KeyboardObserver()
    
    private init() {}
    
    // MARK: Listening Keyboard Notifications
    
    public var isTracking: Bool = false {
        didSet {
            guard oldValue != isTracking else {
                return
            }
            
            if isTracking {
                notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
                notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
                notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
                notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
            } else {
                notificationCenter.removeObserver(self)
            }
        }
    }
    
    @objc
    private func handleNotification(_ notification: NSNotification) {
        let userInfo = UserInfo(userInfo: notification.userInfo ?? [:])
        self.userInfo = userInfo
        
        let observers = self.observers[notification.name]
        
        observers?.forEach {$0.beforeAnimation?(userInfo)}
        
        let options = userInfo.curve.union(.allowUserInteraction)
        UIView.animate(withDuration: userInfo.duration, delay: 0, options: options, animations: {
            observers?.forEach {$0.withinAnimation?(userInfo)}
        }, completion: { finished in
            observers?.forEach {$0.afterAnimation?(userInfo, finished)}
        })
    }
    
    // MARK: Managing Observers
    
    private class ObserverInfo: NSObject {
        var beforeAnimation: ((UserInfo) -> Void)?
        var withinAnimation: ((UserInfo) -> Void)?
        var afterAnimation: ((UserInfo, Bool) -> Void)?
    }
    
    private var observers = [AnyHashable: [ObserverInfo]]()
    
    public func addObserver(for notification: NSNotification.Name, beforeAnimation: ((UserInfo) -> Void)? = nil, withinAnimation: ((UserInfo) -> Void)? = nil, afterAnimation: ((UserInfo, Bool) -> Void)? = nil) -> Disposable {
        let observer = ObserverInfo()
        observer.beforeAnimation = beforeAnimation
        observer.withinAnimation = withinAnimation
        observer.afterAnimation = afterAnimation
        
        observers[notification] = observers[notification, default: []] + [observer]
        
        return Disposables.create { [weak self] in
            if let index = self?.observers[notification]?.index(of: observer) {
                self?.observers[notification]?.remove(at: index)
            }
        }
    }
    
}

