import Foundation
import RxSwift
import RxCocoa
import OAuthSwift
import SafariServices

private enum API {
  
  static let oauthswift = OAuth2Swift(
    consumerKey:    "1211f46766942273935abc6201f1cfe98f8c12b10c0c48d307981a0d3d0cecfc", // consumerKey
    consumerSecret: "ffa1ff732f13e6e0b7162318cfc4373eac0193710a84019d87b47af4c40782c4", // consumerSecret
    authorizeUrl:   "https://dribbble.com/oauth/authorize",
    accessTokenUrl: "https://dribbble.com/oauth/token",
    responseType:   "code"
  )
  
  static func token(_ token: OAuth2Swift.DribbbleToken) -> String {
    return "?access_token=\(token)"
  }
  
  static var tokenObservable: Observable<OAuth2Swift.DribbbleToken> {
    if let token = KeychainManager.getKeychain() {
      return Observable.just(token)
    }
    guard let rootVC = UIViewController.current else { return Observable.empty() }
    
    let handler = SafariURLHandler(viewController: rootVC, oauthSwift: API.oauthswift)
    handler.factory = { url in
      let controller = SFSafariViewController(url: url)
      return controller
    }
    API.oauthswift.authorizeURLHandler = handler
    
    return Observable.just(1)
      .delay(0.1, scheduler: MainScheduler.instance) // delay for showing registration screen
      .flatMap {_ in return API.oauthswift.rx_dribble_authorize() }
      .map {
        KeychainManager.setKeychain(token: $0) // save token
        return $0
    }
  }
}

extension OAuth2Swift {
  
  typealias DribbbleToken = String

  func rx_dribble_authorize() -> Observable<DribbbleToken> {
    return Observable.create { [weak self] observable in
      let task = self?.authorize(
        withCallbackURL: URL(string: "showroom://oauth")!,
        scope: "",
        state: "state1234",
        success: { credential, response, parameters in
          observable.on(.next(credential.oauthToken))
          observable.on(.completed)
      },
        failure: { error in
          observable.on(.error(error))
      })
      return Disposables.create {
        task?.cancel()
      }
    }
  }
}

extension Reactive where Base: URLSession {
  
  func dataWithRecallToken(getURL: String) -> Observable<Data> {
    return API.tokenObservable
      .flatMap { token -> Observable<URLRequest> in
        guard let url = URL(string: getURL + API.token(token)) else { return Observable.empty() }
        return Observable.just(URLRequest(url: url))
      }
      .flatMap { urlRequest -> Observable<Data> in
        return URLSession.shared.rx.data(request: urlRequest)
      }
      .catchError({ (error) -> Observable<Data> in
        switch (error as? RxCocoa.RxCocoaURLError) {
        case .httpRequestFailed(let respose, _)?:
          if respose.statusCode == 401 { // token expired
            KeychainManager.removeKeychain()
            return API.tokenObservable
              .flatMap { token -> Observable<URLRequest> in
                guard let url = URL(string: getURL + API.token(token)) else { return Observable.empty() }
                return Observable.just(URLRequest(url: url))
              }
              .flatMap { urlRequest -> Observable<Data> in
                return URLSession.shared.rx.data(request: urlRequest)
            }
          } else {
            throw error
          }
        default:
          throw error
        }
      })
  }
}
