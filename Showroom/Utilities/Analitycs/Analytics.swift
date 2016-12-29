import Foundation
import Firebase

class Analytics {
    
    enum Types {
        case google
    }
    
    enum ScreenEvents {
        case google(name: String, vc: UIViewController)
    }
    
    enum Events {
        case google(name: String, parametr: String)
    }
    
    // create
    class func configuration(_ analytics: [Analytics.Types]) {
        analytics.forEach { $0.configure() }
    }
}

// MARK: Events
extension Analytics {
    
    class func screen(event: ScreenEvents) {
        switch event {
        case .google(let name, let vc): FIRAnalytics.setScreenName(name, screenClass: vc.classForCoder.description())
        }
    }
    
    class func event(_ event: Analytics.Events) {
        
        switch event {
        case .google(let name, let parametr):
            FIRAnalytics.logEvent(withName: name, parameters: [
                kFIRParameterItemName: parametr as NSObject,
                ])
        }
        
    }
}

// MARK: Configure
private extension Analytics.Types {
    
    func configure() -> Void {
        switch self {
        case .google:
            FIRApp.configure()
        }
    }
}
