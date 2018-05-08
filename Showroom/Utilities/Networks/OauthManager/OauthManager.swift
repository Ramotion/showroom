import Foundation
import OAuthSwift
import SafariServices
import RxSwift
import RxAlamofire

final class OauthManager {
    
    let disposeBag = DisposeBag()
    
    fileprivate var oauthswift = OAuth2Swift(
        consumerKey:    "1211f46766942273935abc6201f1cfe98f8c12b10c0c48d307981a0d3d0cecfc", // consumerKey
        consumerSecret: "ffa1ff732f13e6e0b7162318cfc4373eac0193710a84019d87b47af4c40782c4", // consumerSecret
        authorizeUrl:   "https://dribbble.com/oauth/authorize",
        accessTokenUrl: "https://dribbble.com/oauth/token",
        responseType:   "code"
    )
    
    let session = URLSession.shared
}

// MARK: Methods
extension OauthManager {
    
    func doOAuthDribbble(on viewController: UIViewController) -> Observable<[Shot]> {

        oauthswift.authorizeURLHandler = getURLHandler(on: viewController)
        return oauthswift.rx_dribble_authorize()
            .flatMap { event -> Observable<Data> in
                let request = URLRequest(url: URL(string: "https://api.dribbble.com/v2/user/shots?access_token=\(event)")!)
                return self.session.rx.data(request: request)
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

// MARK: Helpers
private extension OauthManager {
    
    func getURLHandler(on viewController: UIViewController) -> OAuthSwiftURLHandlerType {
        
        let handler = SafariURLHandler(viewController: viewController, oauthSwift: oauthswift)
        handler.presentCompletion = { }
        handler.dismissCompletion = { }
        handler.factory = { url in
            let controller = SFSafariViewController(url: url)
            return controller
        }
        return handler
    }
}
