import UIKit

class ThingersTapViewController: UIViewController {
  @IBOutlet weak var backgroundView: UIView!

  @IBOutlet weak var hand: UIImageView!
  @IBOutlet weak var handTouches: UIImageView!
}

// MARK: Life Cycle
extension ThingersTapViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backgroundView.layer.cornerRadius = 5
    backgroundView.layer.masksToBounds = true
  }
}

// MARK: Methods
extension ThingersTapViewController {
  
  class func showPopup(on: UIViewController) {
    let storybord = UIStoryboard(storyboard: .Navigation)
    let vc: ThingersTapViewController = storybord.instantiateViewController()
    vc.transitioningDelegate = vc
    vc.modalPresentationStyle = .custom
    on.present(vc, animated: true, completion: nil)
  }
}

// MARK: Actions
extension ThingersTapViewController {
  
  @IBAction func GotItHandler(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: transition delegate
extension ThingersTapViewController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ShowAlphaModalTransition(duration: 1)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return HideAlphaModalTransition(duration: 0.8)
  }
}
