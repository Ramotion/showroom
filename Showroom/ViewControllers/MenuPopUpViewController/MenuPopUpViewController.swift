import UIKit
import SwiftyAttributes

fileprivate struct C {
  
  static let Copied = NSLocalizedString("COPIED", comment: "COPIED")
}

class MenuPopUpViewController: UIViewController {

  @IBOutlet weak var menuViewHeight: NSLayoutConstraint!
  @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
  @IBOutlet weak var infoViewBottom: NSLayoutConstraint!
  @IBOutlet weak var copiedLabel: UILabel!
  
  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var menuView: UIView!
  fileprivate var presenter: PopUpPresenter?
}

// MARK: Life Cycle
extension MenuPopUpViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    copiedLabel.attributedText = C.Copied.withKern(1)
    
    infoViewBottom.constant = -infoViewHeight.constant
  }
}

// MARK: Methods
extension MenuPopUpViewController {
  
  class func showPopup(on: UIViewController) {
    
    let storybord = UIStoryboard(storyboard: .Navigation)
    let vc: MenuPopUpViewController = storybord.instantiateViewController()
    vc.presenter = PopUpPresenter(controller: vc,
                                  on: on,
                                  showTransition: ShowMenuPopUpTransition(duration: 1),
                                  hideTransition: ShowMenuPopUpTransition(duration: 0.8))
  }
}

// MARK: Actions
extension MenuPopUpViewController {
  
  @IBAction func copyLinkHandler(_ sender: Any) {
  }
  
  @IBAction func sharedHandler(_ sender: Any) {
  }
  
  @IBAction func backHandler(_ sender: Any) {
  }
}
