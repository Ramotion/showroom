import UIKit
import RxSwift
import RxCocoa

protocol ThreeThingersTouchCompatibility {
  
  var threeThingersToch: ControlEvent<UITapGestureRecognizer> { get }
}

extension ThreeThingersTouchCompatibility where Self: UIViewController {
  
  var threeThingersToch: ControlEvent<UITapGestureRecognizer> {
    
    let gesture = UITapGestureRecognizer()
    gesture.numberOfTouchesRequired = 3
    view.addGestureRecognizer(gesture)
    
    return gesture.rx.event
  }
}

extension UIViewController: ThreeThingersTouchCompatibility {}
