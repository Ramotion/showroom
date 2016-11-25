import UIKit
import RxSwift
import RxCocoa
import EasyPeasy
import NSObject_Rx

class AboutView: UIView {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoText: UILabel!
  @IBOutlet weak var sharedView: UIView!
  @IBOutlet weak var sharedViewBottomConstraints: NSLayoutConstraint!
  @IBOutlet weak var sharedViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  fileprivate var circleView: CircleView?

  var titleView: CarouselTitleView! 
}

// MARK: Life Cycle
extension AboutView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureInfoText()
    
    subscribeSeparatorAnimation()
  }
}

// MARK: Methods
extension AboutView {
  
  func show(on view: UIView) {
    
    if circleView == nil { circleView = .build(on: self, position: titleView.infoButton.center) }
    
    infoText.alpha = 0
    
    titleLabel.alpha = 0
    titleLabel.animate(duration: 0.4, [.alpha(to: 1)], delay: 0.2)
    
    alpha = 0
    animate(duration: 0.2, [.alpha(to: 1)])
    
    view.addSubview(self)
    self <- Edges(0)
    
    circleView?.show()
    
    // move animations
    sharedViewBottomConstraints.constant = -sharedViewHeightConstraint.constant
    titleLabelTopConstraint.constant += 40
    layoutIfNeeded()
    
    sharedViewBottomConstraints.constant = 0
    titleLabelTopConstraint.constant -= 40
    UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseOut, animations: { [weak self] in
      self?.layoutIfNeeded()
    }, completion: nil)
    
    view.bringSubview(toFront: titleView)
//    titleView.backgroundColor = UIColor(white: 1, alpha: 0.96)
  }
  
  func hide(on view: UIView) {
    self.removeFromSuperview()
    
    view.bringSubview(toFront: titleView)
    titleView.backgroundColor = .clear
    titleView.animateSeparator(isShow: false)
    circleView?.hide()
  }
}

// MARK: RX
private extension AboutView {
  
  func subscribeSeparatorAnimation() {
    _ = scrollView.rx.contentOffset
      .map { $0.y > 5 }
      .distinctUntilChanged()
      .subscribe { [weak self] in
        guard let titleView = self?.titleView else { return }
        
        if let isShow = $0.element {
          titleView.animateSeparator(isShow: isShow)
        }
      }
      .addDisposableTo(rx_disposeBag)
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
