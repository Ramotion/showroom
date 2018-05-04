import UIKit
import EasyPeasy

// MARK: OpenControllerTransition
class OpenControllerTransition: NSObject {
  
  let duration: TimeInterval
  
  init(duration: TimeInterval) {
    self.duration = duration
    super.init()
  }
}

extension OpenControllerTransition: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard case let fromViewController as CarouselViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { fatalError() }
    
    
    let  toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
    
    let whiteView = UIView(frame: .zero)
    toView?.addSubview(whiteView)
    whiteView.backgroundColor = .white
    whiteView.easy.layout(Edges())
    
    fromViewController.view?.tintAdjustmentMode     = .dimmed
    fromViewController.view?.isUserInteractionEnabled = false
    
    let containerVeiw = transitionContext.containerView
    toView?.center = containerVeiw.center
    if let toView = toView { containerVeiw.addSubview(toView) }
    
    toView?.alpha = 0
    toView?.animate(duration: duration / 2, [.alpha(to: 1)], timing: .easyInEasyOut)
    
    toView?.animate(duration: 0.001, [.viewScale(from: 1, to: 1.5)])
    toView?.animate(duration: duration / 2, delay: duration / 2, [.viewScale(from: 1.5, to: 1)], timing: .easyInEasyOut)
    
    whiteView.animate(duration: duration / 2, delay: duration / 2, [.alphaFrom(1, to: 0, removed: false)], timing: .easyInEasyOut) {
      whiteView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
    
    fromViewController.transitionController(isOpen: true)
  }
}

// MARK: HideControllerTransition
class HideControllerTransition: NSObject {
  
  let duration: TimeInterval
  
  init(duration: TimeInterval) {
    self.duration = duration
    super.init()
  }
}

extension HideControllerTransition: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard case let toViewController as CarouselViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { fatalError() }
    
    let  fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
    
    toViewController.view.tintAdjustmentMode     = .normal
    toViewController.view.isUserInteractionEnabled = true
    
    fromView?.animate(duration: duration, [.alpha(to: 0)], timing: .easyInEasyOut) {
      transitionContext.completeTransition(true)
    }
    toViewController.transitionController(isOpen: false)
  }
}
