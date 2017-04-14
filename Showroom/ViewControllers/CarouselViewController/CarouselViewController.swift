import UIKit
import EasyPeasy
import Device

extension UINavigationController {
  
  override open var shouldAutorotate: Bool {
    return false
  }
}

fileprivate struct C {
  
  static let radius: CGFloat = 5
}

// MARK: CarouselViewController
class CarouselViewController: UIViewController {
  
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomRectangle: UIImageView!
  @IBOutlet weak var topRectangle: UIImageView!
  @IBOutlet weak var topContainer: CarouselTitleView!
  @IBOutlet var aboutView: AboutView!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var contactUsButton: UIButton!
  @IBOutlet weak var pageLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var bottomContainer: UIView!
  
  fileprivate var isSplashAnimation = true
  
  fileprivate let items: [Showroom.Control] = [
                                               .elongationPreview,
                                               .glidingCollection,
                                               .circleMenu,
                                               .foldingCell,
                                               .paperSwitch,
                                               .paperOnboarding,
                                               .expandingCollection,
                                               .previewTransition,
//                                               .animationTabBar,
//                                               .realSearch,
//                                               .navigationStack,
                                               .vr,
                                                ]
  
  fileprivate var splashBrokerAnimation: CarouselSplashAnimationBroker!
  fileprivate var transitionBrokerAnimation: CarouselTransitionAnimationBroker?
  
  fileprivate var foldingCellVC: UIViewController!
//  fileprivate var searchVC: SearchViewController = UIStoryboard(storyboard: .Main).instantiateViewController()
  
  // Index of current cell
  fileprivate var currentIndex: Int {
    guard let collectionView = self.collectionView else { return 0 }
    
    let startOffset = (collectionView.bounds.size.width - CarouselFlowLayout.cellSize.width) / 2
    guard let collectionLayout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return 0
    }
    
    let minimumLineSpacing = collectionLayout.minimumLineSpacing
    let a = collectionView.contentOffset.x + startOffset + CarouselFlowLayout.cellSize.width / 2
    let b = CarouselFlowLayout.cellSize.width + minimumLineSpacing
    return Int(a / b)
  }
}

// MARK: Life Cycle
extension CarouselViewController {
  
  override open var shouldAutorotate: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.isStatusBarHidden = true
    
    collectionViewHeight.constant = CarouselFlowLayout.cellSize.height
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    
    splashBrokerAnimation = CarouselSplashAnimationBroker(collectionView: collectionView,
                                                          infoButton: infoButton,
                                                          contactUsButton: contactUsButton,
                                                          pageLabel: pageLabel,
                                                          titleContainer: topContainer,
                                                          topRectangle: topRectangle,
                                                          bottomRectangle: bottomRectangle,
                                                          backgroudView: self.view,
                                                          bottomContainer: bottomContainer)
    
    transitionBrokerAnimation = CarouselTransitionAnimationBroker(collectionView: collectionView,
                                                                  infoButton: infoButton,
                                                                  contactUsButton: contactUsButton,
                                                                  pageLabel: pageLabel,
                                                                  titleContainer: topContainer,
                                                                  bottomContainer: bottomContainer)
    configureContactButton()
    pageLabel.text = "\(currentIndex + 1)/\(items.count)"
    aboutView.titleView = topContainer
    collectionView.layer.masksToBounds = false
    
    preloadfoldinCellVC()
    if #available(iOS 10.0, *) {
      collectionView?.isPrefetchingEnabled = false
    }
//    preloadSearchVC()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if isSplashAnimation == true {
      splashBrokerAnimation.startAnimations()
      isSplashAnimation = false
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Analytics.screen(event: .google(name: "CarouselViewController", vc: self))
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}

// MARK: Configure
extension  CarouselViewController {
  
  func configureContactButton() {
    contactUsButton.layer.cornerRadius = C.radius
    contactUsButton.layer.shadowColor = UIColor.black.cgColor
    contactUsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    contactUsButton.layer.shadowRadius = 4
    contactUsButton.layer.shadowOpacity = 0.3
  }
  
  func preloadfoldinCellVC() {
    let foldingVC = UIStoryboard(storyboard: .Main).instantiateViewController() as FoldingTableViewController
    _ = foldingVC.view // preload controller
    foldingCellVC = foldingVC
  }
  
//  func preloadSearchVC() {
//    _ = searchVC.view
//  }
}

// MARK: Methods
extension CarouselViewController {
  
  func transitionController(isOpen: Bool) {
    if isOpen == true {
      transitionBrokerAnimation?.showTranstion(collectionItemIndex: currentIndex)
    } else {
      transitionBrokerAnimation?.hideTranstion(collectionItemIndex: currentIndex)
    }
  }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension CarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard case let cell as ControlCollectionViewCell = cell else { return }
    cell.setInfo(control: items[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.getReusableCellWithIdentifier(indexPath: indexPath) as ControlCollectionViewCell
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let page = "\(currentIndex + 1)/\(items.count)"
    if pageLabel.text != page { pageLabel.text = page }
  }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    
    
    let vc: UIViewController
    switch item {
    case .foldingCell:  vc = foldingCellVC
//    case .realSearch: vc = searchVC
    default: vc = item.viewController
    }

    vc.transitioningDelegate = self
    vc.modalPresentationStyle = .custom
    present(vc, animated: true) { [weak vc] in
      guard let vc = vc else { return }

      Analytics.screen(event: .google(name: item.title, vc: vc))
    }
  }
}

// MARK: Actions
extension CarouselViewController {
  
  @IBAction func infoHandler(_ sender: UIButton) {
    sender.isUserInteractionEnabled = false
    sender.animate(duration: 0, delay: 0, [.springScale(from: 0.9, to: 1, bounce: 20, spring: 10)])
    if sender.isSelected == true {
        Analytics.event(.google(name: "Buttons", parametr: "hide about"))
      aboutView.hide(on: view) {
        sender.isUserInteractionEnabled = true
      }
    } else {
        Analytics.event(.google(name: "Buttons", parametr: "show about"))
        aboutView.show(on: view) {
        sender.isUserInteractionEnabled = true
      }
    }
    sender.isSelected = !sender.isSelected
  }
  
  @IBAction func sharedHandler(_ sender: Any) {
    let sharedUrl = items[currentIndex].sharedURL
    Analytics.event(.google(name: "Buttons", parametr: "control shared: \(sharedUrl)"))
    let activity = UIActivityViewController(activityItems: [sharedUrl], applicationActivities: nil)
    present(activity, animated: true, completion: nil)
  }
  
  @IBAction func contactUsHandler(_ sender: Any) {
    Analytics.event(.google(name: "Buttons", parametr: "contact us"))
    
    if let url = URL(string: "https://business.ramotion.com/?utm_source=showroom&utm_medium=special&utm_campaign=v1/#Contact") {
      UIApplication.shared.open(url)
    }
  }
}

// MARK: transtion delegate
extension CarouselViewController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return OpenControllerTransition(duration: 1)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return HideControllerTransition(duration: 0.5)
  }
}
