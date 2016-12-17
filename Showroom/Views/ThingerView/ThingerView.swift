import UIKit
import RxCocoa
import RxSwift

// MARK: style
private enum Style  {
  case small
}

extension Style {
  
  var size: CGSize {
    return CGSize(width: 44, height: 44)
  }
  
  var corner: CGFloat {
    return size.width / 2
  }
  
  var color: UIColor {
    return .red
  }
}

// MARK: ThingerTapView
class ThingerTapView: UIView {
  
  deinit {
    print("thinger")
  }
  
  enum Animation {
    case tap
  }
}

// MARK: Methods
extension ThingerTapView {
  
  class func create(on view: UIView, type: ThingerTapView.Animation) -> ThingerTapView {
    let thinger = ThingerTapView.create(style: .small)
    
    thinger.center = view.center
    view.addSubview(thinger)
    
    let timer = Observable<NSInteger>.interval(0.8, scheduler: MainScheduler.instance)
      .startWith(0)
      .shareReplayLatestWhileConnected()
    
    _ = timer.subscribe { [weak thinger] _ in
      guard let thinger = thinger else { return }
      
      type.animate(view: thinger)
      }.addDisposableTo(thinger.rx_disposeBag)
    
    return thinger
  }
  
  func show(delay: TimeInterval) {
    animate(duration: 0.2, delay: delay, [.alpha(to: 1)], timing: .easyInEasyOut)
  }
  
  func hide(delay: TimeInterval) {
    pop_removeAllAnimations()
    animate(duration: 0.2, delay: delay, [.alpha(to: 0)], timing: .easyInEasyOut)
  }
}

// MARK: create
private extension UIView {
  
  class func create(style: Style) -> ThingerTapView {
    let view = ThingerTapView(frame: CGRect(origin: .zero, size: style.size))
    view.backgroundColor = style.color
    view.layer.cornerRadius = style.corner
    return view
  }
}

// MARK: Actions
private extension ThingerTapView.Animation {
  
  func animate(view: UIView) {
    
    switch self {
    case .tap: tapAnimation(view: view)
    }
  }
  
  private func tapAnimation(view: UIView) {
    
    view.animate(duration: 0.2, [.viewScale(from: 1, to: 0.8)], timing: .easyInEasyOut)
    view.animate(duration: 0.2, delay: 0.2, [.viewScale(from: 0.8, to: 1)], timing: .easyInEasyOut)
    
//    view.animate(duration: 0.2, [.alphaFrom(0.8, to: 1, removed: false)], timing: .easyInEasyOut)
//    view.animate(duration: 0.2, delay: 0.2, [.alphaFrom(1, to: 0.8, removed: false)], timing: .easyInEasyOut)
  }
}
