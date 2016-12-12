import UIKit

protocol ThreeThingersTouchCompatibility {
  
  func threeThingersToch(_ onTap: @escaping () -> Void) 
}

extension ThreeThingersTouchCompatibility where Self: UIViewController {
  
  func threeThingersToch(_ onTap: @escaping () -> Void) {
    
    let gesture = UITapGestureRecognizer()
    gesture.numberOfTouchesRequired = 3
    view.addGestureRecognizer(gesture)
    
    _ = gesture.rx.event.asObservable().subscribe { _ in onTap() }
  }
}

extension UIViewController: ThreeThingersTouchCompatibility {}
