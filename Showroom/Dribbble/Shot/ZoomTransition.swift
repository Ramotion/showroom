//
//  DribbbleShotTransition.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 02/08/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

protocol ZoomTransitionViewProviding {
    
    func sourceViewForZoomTransition(with identifier: String) -> UIView?
    func destinationViewForZoomTransition(with identifier: String) -> UIView?
    
}

final class ZoomTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Direction {
        case dismissing
        case presenting
    }
    
    private let identifier: String
    private let direction: Direction
    
    init(identifier: String, direction: Direction) {
        self.identifier = identifier
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromViewController = transitionContext.viewController(forKey: .from)
        guard let destinationView = (toViewController as? ZoomTransitionViewProviding)?.destinationViewForZoomTransition(with: identifier),
            let sourceView = (fromViewController as? ZoomTransitionViewProviding)?.destinationViewForZoomTransition(with: identifier) else { return }
        
        switch direction {
        case .presenting:
            animatePresentation(from: sourceView, to: destinationView, using: transitionContext)
        case .dismissing:
            animateDismissal(from: sourceView, to: destinationView, using: transitionContext)
        }
    }
    
    private func animatePresentation(from sourceView: UIView, to destinationView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to),
            let sourceViewSnapshot = sourceView.snapshotView(afterScreenUpdates: false) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        let duration = transitionDuration(using: transitionContext)

        // insert toView
        toView.alpha = 0
        toView.frame = toViewFinalFrame
        containerView.addSubview(toView)
        toView.layoutIfNeeded()

        let destinationViewFrameInContainerView = destinationView.convert(destinationView.bounds, to: containerView)
        let sourceViewFrameInContainerView = sourceView.convert(sourceView.bounds, to: containerView)
        
        // insert source view
        sourceViewSnapshot.frame = sourceViewFrameInContainerView
        containerView.addSubview(sourceViewSnapshot)
        
        // hide source and target views
        destinationView.alpha = 0
        sourceView.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .layoutSubviews], animations: {
            toView.alpha = 1
            sourceViewSnapshot.frame = destinationViewFrameInContainerView
        }, completion: { finished in
            let didComplete = !transitionContext.transitionWasCancelled
            
            destinationView.alpha = 1
            sourceViewSnapshot.removeFromSuperview()
            
            transitionContext.completeTransition(didComplete)
        })
    }
    
    private func animateDismissal(from sourceView: UIView, to destinationView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let sourceViewSnapshot = sourceView.snapshotView(afterScreenUpdates: false) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        let destinationViewFrameInContainerView = destinationView.convert(destinationView.bounds, to: containerView)
        let sourceViewFrameInContainerView = sourceView.convert(sourceView.bounds, to: containerView)

        // insert source view
        sourceViewSnapshot.frame = sourceViewFrameInContainerView
        containerView.addSubview(sourceViewSnapshot)
        
        // hide source and target views
        destinationView.alpha = 0
        sourceView.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .layoutSubviews], animations: {
            fromView.alpha = 0
            sourceViewSnapshot.frame = destinationViewFrameInContainerView
        }, completion: { finished in
            let didComplete = !transitionContext.transitionWasCancelled
            
            sourceViewSnapshot.removeFromSuperview()
            destinationView.alpha = 1
            
            transitionContext.completeTransition(didComplete)
        })
    }
    
}
