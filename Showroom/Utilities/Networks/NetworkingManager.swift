import Foundation
import OAuthSwift
import RxSwift
import SafariServices

final class NetworkingManager {
    
    enum URLString {
        static let base = "https://api.dribbble.com/v2/"
        
        static func token(_ token: OAuth2Swift.DribbbleToken) -> String {
            return "?access_token=\(token)"
        }
        
        static func shots(aToken: OAuth2Swift.DribbbleToken) -> String {
            return base + "user/shots" + token(aToken)
        }
    }
    
    private lazy var oauthswift = OAuth2Swift(
        consumerKey:    "1211f46766942273935abc6201f1cfe98f8c12b10c0c48d307981a0d3d0cecfc", // consumerKey
        consumerSecret: "ffa1ff732f13e6e0b7162318cfc4373eac0193710a84019d87b47af4c40782c4", // consumerSecret
        authorizeUrl:   "https://dribbble.com/oauth/authorize",
        accessTokenUrl: "https://dribbble.com/oauth/token",
        responseType:   "code"
    )
    
    var tokenObservable: Observable<OAuth2Swift.DribbbleToken> {
        if let token = KeychainManager.getKeychain() {
           return Observable.just(token)
        }
        guard let rootVC = UIViewController.current else { return Observable.empty() }

        let handler = SafariURLHandler(viewController: rootVC, oauthSwift: oauthswift)
        handler.factory = { url in
            let controller = SFSafariViewController(url: url)
            return controller
        }
        oauthswift.authorizeURLHandler = handler
        
        return Observable.just(1)
                .delay(0.1, scheduler: MainScheduler.instance)
                .flatMap {_ in
                    return self.oauthswift.rx_dribble_authorize()
                }
            .map {
                KeychainManager.setKeychain(token: $0) // save token
                return $0
        }
    }
}

// MARK: Methods
extension NetworkingManager {
    
    func fetchDribbbleShots() -> Observable<[Shot]> {
        
        return tokenObservable.flatMap { token -> Observable<URLRequest> in
            guard let url = URL(string: URLString.shots(aToken: token)) else { return Observable.empty() }
            return Observable.just(URLRequest(url: url))
            }
            .flatMap { urlRequest -> Observable<Data> in
                return URLSession.shared.rx.data(request: urlRequest)
            }
            .flatMap { data -> Observable<[Shot]> in
                #if DEBUG
                if let json = try? JSONSerialization.jsonObject(with: data) { print(json) }
                #endif
                do {
                    let shots = try JSONDecoder().decode([Shot].self, from: data)
                    return Observable.just(shots)
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                    return Observable.empty()
                }
            }
    }
}
