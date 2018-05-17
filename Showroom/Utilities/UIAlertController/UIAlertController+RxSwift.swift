import UIKit
import RxSwift

extension UIAlertController {
    
    func confirmation() -> Observable<()> {
        return  Observable.create { [weak self] (observer) -> Disposable in
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { _ in
               observer.onNext(())
               observer.onCompleted()
            })
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                observer.onCompleted()
            })
            if let `self` = self {
                self.addAction(actionOk)
                self.addAction(actionCancel)
                
                UIViewController.current?.present(self, animated: true, completion: nil)
            } else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
