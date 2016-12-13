import UIKit

class ThingersTapViewController: UIViewController {
  @IBOutlet weak var backgroundView: UIView!

  @IBOutlet weak var hand: UIImageView!
  @IBOutlet weak var handTouches: UIImageView!
  @IBOutlet weak var infoTextLabel: UILabel!
  
  fileprivate var presenter: PopUpPresenter?
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
    configureInfoLabel()
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
    vc.presenter = PopUpPresenter(controller: vc,
                   on: on,
                   showTransition: ShowAlphaModalTransition(duration: 1),
                   hideTransition: HideAlphaModalTransition(duration: 0.8))
  }
}

// MARK: Configure
extension ThingersTapViewController {
  
  func configureInfoLabel() {
    guard let text = infoTextLabel.text else { return }

    let style = NSMutableParagraphStyle()
    style.lineSpacing = 3
    style.alignment = .center
    let attributedText = text.withAttributes([.paragraphStyle(style)])
    infoTextLabel.attributedText = attributedText
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
