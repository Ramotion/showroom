import UIKit
import EasyPeasy

// MARK: OpenControllerTransition

final class OpenControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {

    enum Direction {
        case presenting
        case dismissing
    }
    
    private let direction: Direction
    private var duration: TimeInterval {
        switch direction {
            case .presenting: return 1.0
            case .dismissing: return 0.5
        }
    }
    
    var animationCompletionHandler: (() -> Void)?
    
    // MARK: Initializer
    init(direction: Direction) {
        self.direction = direction
        super.init()
    }
    
    // MARK: Delegate methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .presenting: animatePresentation(using: transitionContext)
        case .dismissing: animateDismissal(using: transitionContext)
        }
    }
    
    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        
        let whiteView = UIView(frame: .zero)
        toView.addSubview(whiteView)
        whiteView.backgroundColor = .white
        whiteView.easy.layout(Edges())
        
        fromViewController.view?.tintAdjustmentMode     = .dimmed
        fromViewController.view?.isUserInteractionEnabled = false
        
        toView.center = containerView.center
        containerView.addSubview(toView)
        
        toView.alpha = 0
        toView.animate(duration: duration / 2, [.alpha(to: 1)], timing: .easyInEasyOut)
        
        toView.animate(duration: 0.001, [.viewScale(from: 1, to: 1.5)])
        toView.animate(duration: duration / 2, delay: duration / 2, [.viewScale(from: 1.5, to: 1)], timing: .easyInEasyOut)
        
        whiteView.animate(duration: duration / 2, delay: duration / 2, [.alphaFrom(1, to: 0, removed: false)], timing: .easyInEasyOut) {
            whiteView.removeFromSuperview()
//            fromViewController.view?.isUserInteractionEnabled = true
            transitionContext.completeTransition(true)
        }
        
        animationCompletionHandler?()
//        fromViewController.transitionController(isOpen: true)
    }
    
    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }
        
        toViewController.view.tintAdjustmentMode = .normal
        toViewController.view.isUserInteractionEnabled = true
        
        fromView.animate(duration: duration, [.alpha(to: 0)], timing: .easyInEasyOut) {
            transitionContext.completeTransition(true)
        }
        animationCompletionHandler?()
//        toViewController.transitionController(isOpen: false)
    }
}
