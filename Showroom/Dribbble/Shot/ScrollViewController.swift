//
//  ScrollViewController.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 03/08/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit
import RxSwift

/// Base view controller for screens with content embedded in a scroll view
open class ScrollViewController: UIViewController {
    
    public let scrollView: UIScrollView = UIScrollView()
    
    public var scrollContentView: UIView!
    
    private var scrollContentViewHeight: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    
    public var backgroundView: UIView? {
        didSet {
            if let backgroundView = backgroundView {
                backgroundView.frame = view.bounds
                backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.insertSubview(backgroundView, at: 0)
            } else {
                oldValue?.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Managing the View
    
    override open func loadView() {
        super.loadView()
        
        scrollContentView = view!
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        view = UIView(frame: view.bounds)
        view.backgroundColor = scrollContentView.backgroundColor
        
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollContentView)
        
        // content view's edges are pinned to the superview's edges
        // content view's width must be equal to the superview's width
        // content view's height must be equal to the superview's height with a low priority
        let bindings: [String: Any] = ["view": view, "scrollView": scrollView, "scrollContentView": scrollContentView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[scrollContentView(==scrollView)]-(0)-|", options: [], metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[scrollContentView]-(0)-|", options: [], metrics: nil, views: bindings))
        scrollContentViewHeight = scrollContentView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)
        scrollContentViewHeight.priority = UILayoutPriority.defaultLow
        scrollContentViewHeight.isActive = true
        
        // listen for keyboard events
        KeyboardObserver.shared.isTracking = true
    }
    
    // MARK: - Configuring the View’s Layout Behavior
    
    private var viewDidLayoutSubviewsHasBeenTriggered = false
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !viewDidLayoutSubviewsHasBeenTriggered {
            updateScrollViewContentSizeAndInsetsIfNeededWithoutAnimation()
            
            // We have to subscribe to keyboard events right after the parent view controller did automatically update scroll view insets.
            // So we use first layout pass here as a flag to indicate that we need to subscribe for KB events
            KeyboardObserver.shared.addObserver(for: .UIKeyboardWillChangeFrame, withinAnimation: { [weak self] _ in
                self?.updateScrollViewContentSizeAndInsetsIfNeeded()
            }).disposed(by: disposeBag)
        }
        viewDidLayoutSubviewsHasBeenTriggered = true
    }
    
    private func updateScrollViewContentSizeAndInsetsIfNeededWithoutAnimation() {
        // update layout for a case when a view controller is being pushed in a nav stack
        // and the keyboard is already on a screen and comes up from a side of a screen
        // so the content have to be shrinked to visible area before being presented on a screen
        UIView.performWithoutAnimation {
            updateScrollViewContentSizeAndInsetsIfNeeded()
        }
    }
    
    private func updateScrollViewContentSizeAndInsetsIfNeeded() {
        let topInset: CGFloat
        if #available(iOS 11, *) {
            topInset = 0
        } else {
            topInset = topLayoutGuide.length
        }
        
        var bottomInset: CGFloat
        if #available(iOS 11, *) {
            bottomInset = 0
        } else {
            bottomInset = bottomLayoutGuide.length
        }
        bottomInset = max(bottomInset, KeyboardObserver.shared.userInfo?.frameEndBottomInset(in: view) ?? 0)
        if #available(iOS 11, *), bottomInset > scrollView.safeAreaInsets.bottom {
            // Ignore safeAreaInsets when keyboard is visible on screen
            bottomInset -= scrollView.safeAreaInsets.bottom
        }
        
        let contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        if scrollView.contentInset != contentInset {
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = scrollView.contentInset
            scrollViewContentInsetDidChange()
        }
        
        var contentViewHeightConstant = -contentInset.top - contentInset.bottom
        if #available(iOS 11, *) {
            // Here we are getting safeAreaInsets of a view instead of scrollView.
            // Because safe area insets does not propagate to subviews right after `viewWillAppear` call
            // and `scrollView` have zero safe area insets, so
            // we assume that `view` and `scrollView` have similar safe are insets.
            contentViewHeightConstant -= view.safeAreaInsets.top + view.safeAreaInsets.bottom
        }
        
        if scrollContentViewHeight.constant != contentViewHeightConstant {
            scrollContentViewHeight.constant = contentViewHeightConstant
            view.layoutIfNeeded()
            scrollView.flashScrollIndicators()
        }
    }
    
    open func scrollViewContentInsetDidChange() {
        // empty implementation. for subclasses only
    }
    
}

