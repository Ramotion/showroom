import UIKit
import SwiftyAttributes

fileprivate struct C {
  
  static let Copied = NSLocalizedString("COPIED", comment: "COPIED")
}

class MenuPopUpViewController: UIViewController {

  @IBOutlet weak var copiedLabel: UILabel!
}

// MARK: Life Cycle
extension MenuPopUpViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    copiedLabel.attributedText = C.Copied.withKern(1)
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
