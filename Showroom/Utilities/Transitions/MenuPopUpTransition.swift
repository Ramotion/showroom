import UIKit

// MARK: ShowMenuPopUpTransition
class ShowMenuPopUpTransition: NSObject {
  
  let duration: TimeInterval
  
  init(duration: TimeInterval) {
    self.duration = duration
    super.init()
  }
}

extension ShowMenuPopUpTransition: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard case let toViewController as MenuPopUpViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { fatalError() }
    
    
    let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
    
    fromView?.tintAdjustmentMode     = .dimmed
    fromView?.isUserInteractionEnabled = false
    
    let containerVeiw = transitionContext.containerView
    toViewController.view.center = containerVeiw.center
    containerVeiw.addSubview(toViewController.view)
    
    // animation
    toViewController.view?.alpha = 0
    toViewController.view?.animate(duration: duration, [.alphaFrom(0, to: 1, removed: false)])
    
    toViewController.menuView.animate(duration: duration,
                                      [
                                        .layerPositionY(from: Showroom.screen.height + toViewController.menuViewHeight.constant / 2,
                                                       to: Showroom.screen.height - toViewController.menuViewHeight.constant / 2)
                            ],
                                      timing: .easyOut) {
                                        transitionContext.completeTransition(true)
                                      }
  }
}

// MARK: HideMenuPopUpTransition
class HideMenuPopUpTransition: NSObject {
  
  let duration: TimeInterval
  
  init(duration: TimeInterval) {
    self.duration = duration
    super.init()
  }
}

extension HideMenuPopUpTransition: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard case let fromViewController as MenuPopUpViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { fatalError() }
    
    let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
    toView?.tintAdjustmentMode     = .normal
    toView?.isUserInteractionEnabled = true
    
    // animation
    fromViewController.view.animate(duration: duration, [.alphaFrom(1, to: 0, removed: false)]) {
      transitionContext.completeTransition(true)
    }
    
    fromViewController.menuView.animate(duration: duration,
                                      [
                                        .layerPositionY(from: Showroom.screen.height - fromViewController.menuViewHeight.constant / 2,
                                                        to: Showroom.screen.height + fromViewController.menuViewHeight.constant / 2)
      ],
                                      timing: .easyIn)
  }
}
