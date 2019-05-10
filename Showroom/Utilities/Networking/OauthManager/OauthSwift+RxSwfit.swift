import Foundation
import RxSwift
import RxCocoa
import OAuthSwift

private enum API {
  
  static let oauthswift = OAuth2Swift(
    consumerKey:    "7fab3efc357e770a5713317bf458da381b37eaf91e74b999a9dc928cd0c9b5cc", // consumerKey
    consumerSecret: "8fd6a6b8bfd066dfee15d468c47756489be2c376bc32a94ffd309fc118a80428", // consumerSecret
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
  
  func dataWithRecallToken(getURL: String, parametrs: [String]?) -> Observable<Data> {
    let parametrString = parametrs?.reduce("") { $0 + "&" + $1 } ?? ""
    return API.tokenObservable
      .flatMap { token -> Observable<URLRequest> in
        guard let url = URL(string: getURL + API.token(token) + parametrString) else { return Observable.empty() }
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
                guard let url = URL(string: getURL + API.token(token) + parametrString) else { return Observable.empty() }
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
