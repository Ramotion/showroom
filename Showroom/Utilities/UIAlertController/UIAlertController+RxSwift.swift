import UIKit
import RxSwift
import EasyPeasy

// MARK: Default alerts
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

// MARK: Custom allert view
extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}

protocol CustomAlertCompatibility {
    var closeAction: (() -> Void)? { get set }
    func presentAlert()
}

extension CustomAlertCompatibility where Self: UIView {
    func presentAlert() {
        var alertView = self
        let vc  = UIViewController()
        vc.modalPresentationStyle = .custom
        vc.view.backgroundColor = .clear
        vc.view.addSubview(alertView)
        alertView.backgroundColor = .white
        alertView.easy.layout(Edges())
        alertView.closeAction = { [weak vc] in vc?.dismiss(animated: true, completion: nil) }
        
        if let topVC = UIApplication.getTopMostViewController() { topVC.present(vc, animated: true, completion: nil) }
    }
}

extension CustomAlertCompatibility where Self: UIViewController {
    func presentAlert() {
        var vc = self
        vc.closeAction = { [weak vc] in vc?.dismiss(animated: true, completion: nil) }
        if let topController = UIApplication.getTopMostViewController() { topController.present(vc, animated: true, completion: nil) }
    }
}
