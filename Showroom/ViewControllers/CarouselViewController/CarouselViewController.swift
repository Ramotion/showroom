import UIKit

fileprivate struct C {
  
  static let radius: CGFloat = 5
}

// MARK: CarouselViewController
class CarouselViewController: UIViewController {
  
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var contactUsButton: UIButton!
  @IBOutlet weak var pageLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
}

// MARK: Life Cycle
extension CarouselViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureContactButton()
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
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.getReusableCellWithIdentifier(indexPath: indexPath) as ControlCollectionViewCell
  }
}

// MARK: Actions
extension CarouselViewController {
  
  @IBAction func infoHandler(_ sender: Any) {
  }
  
  @IBAction func sharedHandler(_ sender: Any) {
  }
  
  @IBAction func contactUsHandler(_ sender: Any) {
  }
}
