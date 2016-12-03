import UIKit

class PopUpPresenter: NSObject {
  
  let showTransition: UIViewControllerAnimatedTransitioning
  let hideTransition: UIViewControllerAnimatedTransitioning
  
  init(controller: UIViewController,
       on: UIViewController,
       showTransition: UIViewControllerAnimatedTransitioning,
       hideTransition: UIViewControllerAnimatedTransitioning) {
    
    self.showTransition = showTransition
    self.hideTransition = hideTransition
    super.init()
    
    controller.transitioningDelegate = self
    controller.modalPresentationStyle = .custom
    on.present(controller, animated: true, completion: nil)
  }
}

// MARK: transition delegate
extension PopUpPresenter: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return showTransition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return hideTransition
  }
}
