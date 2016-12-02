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
    handTouches.alpha = 0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    heandAnimation()
  }
}

private var isAlredyShow = false

// MARK: Methods
extension ThingersTapViewController {
  
  class func showPopup(on: UIViewController) {
    if isAlredyShow == true { return }
    isAlredyShow = true
    
    let storybord = UIStoryboard(storyboard: .Navigation)
    let vc: ThingersTapViewController = storybord.instantiateViewController()
    vc.transitioningDelegate = vc
    vc.modalPresentationStyle = .custom
    on.present(vc, animated: true, completion: nil)
  }
}

// MARK: Animations
private extension ThingersTapViewController {
  
  func heandAnimation() {
    
    hand.animate(duration: 0.1, delay: 0.6, [.layerScale(from: 1, to: 1.1)], timing: .easyIn)
    hand.animate(duration: 0, delay: 0.7, [.springScale(from: 1.1, to: 1, bounce: 9, spring: 5)])
    
    handTouches.animate(duration: 0.4, delay: 0.9, [.alphaFrom(0, to: 1, removed: false)], timing: .linear)
    handTouches.animate(duration: 0.4, delay: 1.3, [.alphaFrom(1, to: 0, removed: false)], timing: .linear)
    handTouches.animate(duration: 0.4, delay: 1.7, [.alphaFrom(0, to: 1, removed: false)], timing: .linear)
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
