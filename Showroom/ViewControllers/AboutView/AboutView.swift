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
  @IBOutlet weak var learnMoreLabel: UIButton!
  @IBOutlet weak var learnMoreSpace: NSLayoutConstraint!
  @IBOutlet weak var learnMoreHeight: NSLayoutConstraint!
  
  @IBOutlet weak var infoTextHeightconstraint: NSLayoutConstraint!
  @IBOutlet weak var infoTextTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
  @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  fileprivate var circleView: CircleView?
  
  @IBOutlet weak var topView: AboutTopView!
  @IBOutlet weak var topViewHeight: NSLayoutConstraint!
  
  var titleView: CarouselTitleView!
  
  let transperentView: UIView = .build(color: UIColor(red:0.16, green:0.23, blue:0.33, alpha:1.00), alpha: 0)
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
  
  func show(on view: UIView, completion: @escaping () -> Void) {
    
    
    if circleView == nil { circleView = .build(on: self, position: titleView.infoButton.center) }
    scrollView.alpha = 1
    scrollView.contentOffset.y = 0
    
    view.addSubview(self)
    self <- Edges(0)
    
    view.layoutIfNeeded()
    print(infoText.bounds.size.height)
    
    view.bringSubview(toFront: titleView)
    
    circleView?.show()
    topViewHeight.constant = titleView.bounds.size.height
    
    superview?.insertSubview(transperentView, belowSubview: self)
    transperentView <- Edges(0)
    transperentView.alpha = 0
    transperentView.animate(duration: 0.4, [.alphaFrom(0, to: 0.4, removed: false)])

    // move animations
    sharedView.pop_removeAllAnimations()
    sharedView.alpha = 0
    sharedView.animate(duration: 0.001, delay: 0.4, [.alpha(to: 1)])
    sharedView.animate(duration: 0.8, delay: 0.4,
                       [
                        .layerPositionY(from: Showroom.screen.height + sharedViewHeightConstraint.constant / 2,
                                        to: Showroom.screen.height - sharedViewHeightConstraint.constant / 2)
                       ],
                       completion: completion)
    
    titleLabel.pop_removeAllAnimations()
    titleLabel.alpha = 0
    titleLabel.animate(duration: 0.4, delay: 0.2, [.alphaFrom(0, to: 1, removed: false)])
    titleLabel.animate(duration: 0.6, delay: 0.2,
                       [.layerPositionY(from: titleLabelTopConstraint.constant + titleLabelHeight.constant / 2 + sharedViewHeightConstraint.constant / 2,
                                        to: titleLabelTopConstraint.constant + titleLabelHeight.constant / 2)
                       ])
    
    infoText.pop_removeAllAnimations()
    infoText.alpha = 0
    infoText.animate(duration: 0.5, delay: 0.3, [.alphaFrom(0, to: 1, removed: false)])
    let from = titleLabelTopConstraint.constant + titleLabelHeight.constant + infoText.bounds.size.height / 2 + infoTextTopConstraint.constant + sharedViewHeightConstraint.constant / 2
    infoText.animate(duration: 0.7, delay: 0.3, [.layerPositionY(from: from, to: from - sharedViewHeightConstraint.constant / 2)])
    
    learnMoreLabel.pop_removeAllAnimations()
    learnMoreLabel.alpha = 0
    learnMoreLabel.animate(duration: 0.5, delay: 0.3, [.alphaFrom(0, to: 1, removed: false)])
    let infofrom = titleLabelTopConstraint.constant + titleLabelHeight.constant + infoText.bounds.size.height + infoTextTopConstraint.constant 
    let lfrom = infofrom + learnMoreSpace.constant + learnMoreHeight.constant / 2 + sharedViewHeightConstraint.constant / 2
    learnMoreLabel.animate(duration: 0.7, delay: 0.3, [.layerPositionY(from: lfrom, to: lfrom - sharedViewHeightConstraint.constant / 2)])
    
  }
  
  func hide(on view: UIView, completion: @escaping () -> Void) {
    
    print(infoText.bounds.size.height)
   
    scrollView.animate(duration: 0.3, [.alpha(to: 0)], timing: .easyInEasyOut)
    transperentView.animate(duration: 0.4, [.alphaFrom(0.4, to: 0, removed: false)])
    topView.animateSeparator(isShow: false)
    circleView?.hide() { [weak self] in
      self?.transperentView.removeFromSuperview()
      self?.removeFromSuperview()
      completion()
    }
  }
}

// MARK: RX
private extension AboutView {
  
  func subscribeSeparatorAnimation() {
    _ = scrollView.rx.contentOffset
      .map { $0.y > 5 }
      .distinctUntilChanged()
      .subscribe { [weak self] in
        guard let topView = self?.topView else { return }
        
        if let isShow = $0.element {
          topView.animateSeparator(isShow: isShow)
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
    let attributedText = text.withAttributes([
      .paragraphStyle(style),
      .font(font)]
    )
    infoText.attributedText = attributedText
  }
}
