import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController {
  
  private enum Theme {
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
  }
  
  @IBOutlet weak var onboarding: PaperOnboarding!
  
  fileprivate let items = [
    OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Hotels"),
                       title: "Hotels",
                       description: "All hotels and hostels are sorted by hospitality rating",
                       pageIcon: #imageLiteral(resourceName: "Key"),
                       color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Theme.titleFont, descriptionFont: Theme.descriptionFont),
    
    OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Banks"),
                       title: "Banks",
                       description: "We carefully verify all banks before add them into the app",
                       pageIcon: #imageLiteral(resourceName: "Wallet"),
                       color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Theme.titleFont, descriptionFont: Theme.descriptionFont),
    
    OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Stores"),
                       title: "Stores",
                       description: "All local stores are categorized for your convenience",
                       pageIcon: #imageLiteral(resourceName: "Shopping-cart"),
                       color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Theme.titleFont, descriptionFont: Theme.descriptionFont),
    ]
  
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
  
  func onboardingItem(at index: Int) -> OnboardingItemInfo {
   return items[index]
  }
  
  func onboardingItemsCount() -> Int {
    return items.count
  }
}

