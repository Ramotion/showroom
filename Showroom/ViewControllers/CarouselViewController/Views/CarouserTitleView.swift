import UIKit

class CarouselTitleView: UIView {
  
   @IBOutlet weak var infoButton: UIButton!
   @IBOutlet weak var separator: UIView!
}

// MARK: Life Cycle
extension CarouselTitleView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animateSeparator(isShow: false, animated: false)
    }
}

// MARK: Methods
extension CarouselTitleView {
    
    func animateSeparator(isShow: Bool, animated: Bool = true) {
        let value: CGFloat = isShow == true ? 1 : 0
        guard separator.alpha != value else { return }

        guard animated == true else {
            separator.pop_removeAllAnimations()
            separator.alpha = value
            return
        }
        
        separator.animate(duration: 0.3, [.alpha(to: value)])
    }
}
