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
  
  @IBOutlet weak var infoTextHeightconstraint: NSLayoutConstraint!
  @IBOutlet weak var infoTextTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
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
    
    view.addSubview(self)
    self <- Edges(0)
    view.bringSubview(toFront: titleView)
    
    circleView?.show() { [weak self] in
      self?.titleView.backgroundColor = UIColor(white: 1, alpha: 0.96)
    }
    
    alpha = 0
    animate(duration: 0.4, [.alphaFrom(0, to: 1, removed: false)])

    // move animations
    sharedView.pop_removeAllAnimations()
    sharedView.alpha = 0
    sharedView.animate(duration: 0.001, delay: 0.4, [.alpha(to: 1)])
    sharedView.animate(duration: 0.6, delay: 0.3,
                       [
                        .layerPositionY(from: Showroom.screen.height + sharedViewHeightConstraint.constant / 2,
                                        to: Showroom.screen.height - sharedViewHeightConstraint.constant / 2)
                       ])
    
    titleLabel.pop_removeAllAnimations()
    titleLabel.alpha = 0
    titleLabel.animate(duration: 0.4, delay: 0.2, [.alphaFrom(0, to: 1, removed: false)])
    titleLabel.animate(duration: 0.4, delay: 0.2,
                       [.layerPositionY(from: titleLabelTopConstraint.constant + titleLabelHeight.constant / 2 + sharedViewHeightConstraint.constant / 2,
                                        to: titleLabelTopConstraint.constant + titleLabelHeight.constant / 2)
                       ])
    
    infoText.pop_removeAllAnimations()
    infoText.alpha = 0
    infoText.animate(duration: 0.5, delay: 0.3, [.alphaFrom(0, to: 1, removed: false)])
    let from = titleLabelTopConstraint.constant + titleLabelHeight.constant + infoTextHeightconstraint.constant / 2 + infoTextTopConstraint.constant + sharedViewHeightConstraint.constant / 2
    infoText.animate(duration: 0.5, delay: 0.3, [.layerPositionY(from: from, to: from - sharedViewHeightConstraint.constant / 2)])
    
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
