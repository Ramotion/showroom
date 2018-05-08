import Foundation
import RxSwift
import OAuthSwift

extension OAuth2Swift {
  
  func rx_dribble_authorize() -> Observable<String> {
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

