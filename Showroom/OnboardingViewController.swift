import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController {
  
  @IBOutlet weak var onboarding: PaperOnboarding!
  
}

// MARK: Life Cycle
extension OnboardingViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    _ = MenuPopUpViewController.showPopup(on: self, url: "https://github.com/Ramotion/paper-onboarding") { [weak self] in
      self?.navigationController?.dismiss(animated: true, completion: nil)
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    ThingersTapViewController.showPopup(on: self)
  }
}

extension OnboardingViewController: PaperOnboardingDelegate {
  
  func onboardingWillTransitonToIndex(_ index: Int) {
  }
  
  func onboardingDidTransitonToIndex(_ index: Int) {
    
  }
  
  func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {

  }
}

// MARK: PaperOnboardingDataSource
extension OnboardingViewController: PaperOnboardingDataSource {
  
  func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
    let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    return [
      ("Hotels", "Hotels", "All hotels and hostels are sorted by hospitality rating", "Key", UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
      ("Banks", "Banks", "We carefully verify all banks before add them into the app", "Wallet", UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
      ("Stores", "Stores", "All local stores are categorized for your convenience", "Shopping-cart", UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont)
      ][index]
  }
  
  func onboardingItemsCount() -> Int {
    return 3
  }
}

