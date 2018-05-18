import UIKit
import RxSwift

extension UIAlertController {
    
    static func confirmation(message: String) -> Observable<String> {
        return  Observable.create { (observer) -> Disposable in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] _ in
                observer.onNext(alert?.textFields?.first?.text ?? "")
                observer.onCompleted()
            })
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                observer.onCompleted()
            })
            
            alert.addAction(actionOk)
            alert.addAction(actionCancel)
            alert.addTextField(configurationHandler: {
                $0.placeholder = "Optional message"
            })
            
            UIViewController.current?.present(alert, animated: true, completion: nil)
            return Disposables.create()
        }
    }
    
    static func show(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in })
        alert.addAction(actionOk)
        UIViewController.current?.present(alert, animated: true, completion: nil)
    }
}
