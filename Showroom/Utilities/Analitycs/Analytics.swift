import Foundation
import Firebase

class AppAnalytics {
    
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
    class func configuration(_ analytics: [AppAnalytics.Types]) {
        analytics.forEach { $0.configure() }
    }
}

// MARK: Events
extension AppAnalytics {
    
    class func screen(event: ScreenEvents) {
        switch event {
        case .google(let name, let vc): Analytics.setScreenName(name, screenClass: vc.classForCoder.description())
        }
    }
    
    class func event(_ event: AppAnalytics.Events) {
        
        switch event {
        case .google(let name, let parametr):
            Analytics.logEvent(name, parameters: [
                AnalyticsParameterItemName: parametr as NSObject,
                ])
        }
        
    }
}

// MARK: Configure
private extension AppAnalytics.Types {
    
    func configure() -> Void {
        switch self {
        case .google:
            FirebaseApp.configure()
        }
    }
}
