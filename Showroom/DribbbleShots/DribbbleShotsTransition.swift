//
//  DribbbleShotsTransition.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 02/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

protocol DribbbleShotsTransitionSource {
    func dribbbleShotsTransitionSourceView() -> UIView
}

protocol DribbbleShotsTransitionDestination {
}

final class DribbbleShotsTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Direction {
        case dismissing(destinationView: UIView)
        case presenting(sourceView: UIView)
    }
    
    private let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.23
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .presenting(let sourceView):
            animatePresentation(from: sourceView, using: transitionContext)
        case .dismissing(let destinationView):
            animateDismissal(to: destinationView, using: transitionContext)
        }
    }
    
    private func animatePresentation(from sourceView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        let duration = transitionDuration(using: transitionContext)
        
        toView.alpha = 0
        toView.frame = toViewFinalFrame
        containerView.addSubview(toView)
        
        let maskViewInitialFrame = sourceView.convert(sourceView.bounds, to: containerView)
        let maskView = UIView(frame: maskViewInitialFrame)
        maskView.backgroundColor = .black
        toView.mask = maskView
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            toView.alpha = 1
            maskView.frame = toView.bounds
        }, completion: { finished in
            let didComplete = !transitionContext.transitionWasCancelled
            
            if !didComplete {
                toView.removeFromSuperview()
            } else {
                toView.mask = nil
            }
            
            transitionContext.completeTransition(didComplete)
        })
    }
    
    private func animateDismissal(to destinationView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        let maskViewFinalFrame = destinationView.convert(destinationView.bounds, to: containerView)
        let maskView = UIView(frame: fromView.bounds)
        maskView.backgroundColor = .black
        fromView.mask = maskView
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            fromView.alpha = 0
            maskView.frame = maskViewFinalFrame
        }, completion: { finished in
            let didComplete = !transitionContext.transitionWasCancelled
            
            if didComplete {
                fromView.removeFromSuperview()
            } else {
                fromView.mask = nil
            }
            
            transitionContext.completeTransition(didComplete)
        })
    }
    
}
