import Foundation
import UIKit

// MARK: ShowAlphaModalTransition
class ShowAlphaModalTransition: NSObject {
  
  let duration: TimeInterval
  
  init(duration: TimeInterval) {
    self.duration = duration
    super.init()
  }
}

extension ShowAlphaModalTransition: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard case let toViewController as ThingersTapViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { fatalError() }

    
    let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
    
    fromView?.tintAdjustmentMode     = .dimmed
    fromView?.isUserInteractionEnabled = false
    
    
    let containerVeiw = transitionContext.containerView
    toViewController.view.center = containerVeiw.center
    containerVeiw.addSubview(toViewController.view)
    
    // animation
    toViewController.view?.alpha = 0
    toViewController.view?.animate(duration: duration / 2, [.alphaFrom(0, to: 1, removed: false)])
    
    toViewController.backgroundView.animate(duration: 0, [.springScale(from: 0.5, to: 1, bounce: 10, spring: 5)], timing: .easyInEasyOut) {
      transitionContext.completeTransition(true)
    }
  }
}

// MARK: ShowAlphaModalTransition
class HideAlphaModalTransition: NSObject {
  
  let duration: TimeInterval
  
  init(duration: TimeInterval) {
    self.duration = duration
    super.init()
  }
}

extension HideAlphaModalTransition: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard case let fromViewController as ThingersTapViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { fatalError() }
    
    let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
    toView?.tintAdjustmentMode     = .normal
    toView?.isUserInteractionEnabled = true
    
    // animation
    fromViewController.view.animate(duration: duration / 2, [.alphaFrom(1, to: 0, removed: false)]) {
      transitionContext.completeTransition(true)
    }
    
    fromViewController.backgroundView.animate(duration: duration / 2, [.viewScale(from: 1, to: 0.8)], timing: .easyInEasyOut)
  }
}
