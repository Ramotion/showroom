import UIKit
import ExpandingCollection

class DemoCollectionViewCell: BasePageCollectionCell {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var customTitle: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      customTitle.layer.shadowRadius = 2
      customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
      customTitle.layer.shadowOpacity = 0.2
    }
}
