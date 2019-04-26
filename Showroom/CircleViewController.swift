import UIKit
import CircleMenu
import RxCocoa
import RxSwift

class CircleViewController: UIViewController {

  @IBOutlet weak var circleButton: CircleMenu!
  
  fileprivate let items: [(icon: String, color: UIColor)] = [
    ("homeButton", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
    ("searchButton", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
    ("notificationsButton", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
    ("settingsButton", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
    ("nearbyButton", UIColor(red:1, green:0.39, blue:0, alpha:1)),
    ]
}


// MARK: Life Cycle
extension CircleViewController {
  
  override open var shouldAutorotate: Bool {
    return false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    circleButton.delegate = self
    
    MenuPopUpViewController.showPopup(on: self, url: Showroom.Control.circleMenu.sharedURL) { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    ThingersTapViewController.showPopup(on: self)
  }
}

extension CircleViewController: CircleMenuDelegate {
  
  func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
    button.backgroundColor = items[atIndex].color
    
    button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
    
    // set highlited image
    let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
    button.setImage(highlightedImage, for: .highlighted)
    button.tintColor = UIColor.white.withAlphaComponent(0.3)
  }
}
