import UIKit
import EasyPeasy

fileprivate struct C {
  
  static let radius: CGFloat = 5
  static let itemSize: CGSize = CGSize(width: 307, height: 400)
  
}

// MARK: CarouselViewController
class CarouselViewController: UIViewController {
  
  @IBOutlet weak var topContainer: UIView!
  @IBOutlet var aboutView: UIView!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var contactUsButton: UIButton!
  @IBOutlet weak var pageLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  fileprivate let items: [Showroom.Control] = [.circleMenu,
                                               .foldingCell,
                                               .paperSwitch,
                                               .paperOnboarding,
                                               .expandingCollection,
                                               .previewTransition,
                                               .animationTabBar,
                                               .realSearch,
                                               .navigationStack]
  
  // Index of current cell
  fileprivate var currentIndex: Int {
    guard let collectionView = self.collectionView else { return 0 }
    
    let startOffset = (collectionView.bounds.size.width - C.itemSize.width) / 2
    guard let collectionLayout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return 0
    }
    
    let minimumLineSpacing = collectionLayout.minimumLineSpacing
    let a = collectionView.contentOffset.x + startOffset + C.itemSize.width / 2
    let b = C.itemSize.width + minimumLineSpacing
    return Int(a / b)
  }
}

// MARK: Life Cycle
extension CarouselViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureContactButton()
    pageLabel.text = "\(currentIndex + 1)/\(items.count)"
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
}

// MARK: Actions
extension CarouselViewController {
  
  @IBAction func infoHandler(_ sender: UIButton) {
    if sender.isSelected == true {
      hideAboutView()
    } else {
      showAboutView()
    }
    sender.isSelected = !sender.isSelected
  }
  
  @IBAction func sharedHandler(_ sender: Any) {
  }
  
  @IBAction func contactUsHandler(_ sender: Any) {
  }
}

// MARK: Helpers
private extension CarouselViewController {
  
  func showAboutView() {
    view.addSubview(aboutView)
    aboutView <- Edges(0)
    
    view.bringSubview(toFront: topContainer)
    topContainer.backgroundColor = UIColor(white: 1, alpha: 0.96)
  }
  
  func hideAboutView() {
    aboutView.removeFromSuperview()
    
    view.bringSubview(toFront: topContainer)
    topContainer.backgroundColor = .clear
  }
}
