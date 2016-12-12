import UIKit
import RAMPaperSwitch

class SwitchViewController: UIViewController {
  
  @IBOutlet weak var connectContactsLabel: UILabel!
  @IBOutlet weak var phone1ImageView: UIImageView!
  @IBOutlet weak var paperSwitch1: RAMPaperSwitch!
  
  @IBOutlet weak var allowDiscoveryLabel: UILabel!
  @IBOutlet weak var phone2ImageView: UIImageView!
  @IBOutlet weak var paperSwitch2: RAMPaperSwitch!
}

// MARK: SwitchViewController
extension SwitchViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupPaperSwitch()
    
    MenuPopUpViewController.showPopup(on: self) { [weak self] in
      self?.navigationController?.dismiss(animated: true, completion: nil)
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    ThingersTapViewController.showPopup(on: self)
  }
}



extension SwitchViewController {
  
  fileprivate func setupPaperSwitch() {
    
    self.paperSwitch1.animationDidStartClosure = {(onAnimation: Bool) in
      
      self.animateLabel(self.connectContactsLabel, onAnimation: onAnimation, duration: self.paperSwitch1.duration)
      self.animateImageView(self.phone1ImageView, onAnimation: onAnimation, duration: self.paperSwitch1.duration)
    }
    
    
    self.paperSwitch2.animationDidStartClosure = {(onAnimation: Bool) in
      
      self.animateLabel(self.self.allowDiscoveryLabel, onAnimation: onAnimation, duration: self.paperSwitch2.duration)
      self.animateImageView(self.phone2ImageView, onAnimation: onAnimation, duration: self.paperSwitch2.duration)
    }
  }
  
  fileprivate func animateLabel(_ label: UILabel, onAnimation: Bool, duration: TimeInterval) {
    UIView.transition(with: label, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
      label.textColor = onAnimation ? UIColor.white : UIColor(red: 31/255.0, green: 183/255.0, blue: 252/255.0, alpha: 1)
      }, completion:nil)
  }
  
  fileprivate func animateImageView(_ imageView: UIImageView, onAnimation: Bool, duration: TimeInterval) {
    UIView.transition(with: imageView, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
      imageView.image = UIImage(named: onAnimation ? "img_phone_on" : "img_phone_off")
      }, completion:nil)
  }
}
