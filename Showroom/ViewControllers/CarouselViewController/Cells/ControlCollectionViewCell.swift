import UIKit
import SwiftyAttributes

fileprivate struct C {
  
  static let corner: CGFloat = 5
}

class ControlCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var previewImageContainer: UIView!
  @IBOutlet weak var PreviewImage: UIImageView!
  @IBOutlet weak var controlTitleLabel: UILabel!
  @IBOutlet weak var shareButton: UIButton!
  @IBOutlet weak var settingsLabel: UILabel!
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
}

// MARK: Life Cycle
extension ControlCollectionViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureAppearence()
  }
}

// MARK: Methods
extension ControlCollectionViewCell {
  
  func setInfo(control: Showroom.Control) {
    controlTitleLabel.text = control.title
    hoursLabel.text = "\(control.hours) Human Hours"
    settingsLabel.text = control.languages
    setInfoText(text: control.info)
  }
}

// MARK: Helpers
private extension ControlCollectionViewCell {
  
  func setInfoText(text: String) {
    guard let font = UIFont(name: "Graphik-Regular", size: 14) else { return }
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 6
    infoLabel.attributedText = text.withAttributes([
      .paragraphStyle(style),
      .font(font)]
    )
  }
  
  func configureAppearence() {
    layer.cornerRadius = C.corner
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 2
    layer.shadowOpacity = 0.02
    layer.masksToBounds = false
    previewImageContainer.layer.cornerRadius = 5
    previewImageContainer.layer.masksToBounds = true
  }
}
