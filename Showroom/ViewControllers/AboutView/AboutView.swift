import UIKit
import EasyPeasy

class AboutView: UIView {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoText: UILabel!
  
  var titleView: CarouselTitleView!
  
}

// MARK: Life Cycle
extension AboutView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureInfoText()
  }
}

// MARK: Methods
extension AboutView {
  
  func show(on view: UIView) {
    view.addSubview(self)
    self <- Edges(0)
    
    view.bringSubview(toFront: titleView)
    titleView.backgroundColor = UIColor(white: 1, alpha: 0.96)
  }
  
  func hide(on view: UIView) {
    self.removeFromSuperview()
    
    view.bringSubview(toFront: titleView)
    titleView.backgroundColor = .clear
  }
}

// MARK: Helpers 
private extension AboutView {
  
  func configureInfoText() {
    guard let text = infoText.text else { return }

    guard let font = UIFont(name: "Graphik-Regular", size: 16) else { return }
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 7
    infoText.attributedText = text.withAttributes([
      .paragraphStyle(style),
      .font(font)]
    )
  }
}
