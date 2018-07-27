import Foundation
import OAuthSwift
import RxSwift
import SafariServices

final class NetworkingManager {
    
    enum URLString {
        static let base = "https://api.dribbble.com/v2/"
        static let user = base + "user"
        static let shots = base + "user/shots"
    }
}

// MARK: Methods
extension NetworkingManager {
    
    func fetchDribbbleUser() -> Observable<User> {
        let data = """
{
    "id": 0,
    "name": "name",
    "html_url": "https://cdn.dribbble.com/users/824641/screenshots/4773637",
}
""".data(using: .utf8)!
        
        return Observable<User>.create { subscribtion in
            do {
                let object = try JSONDecoder().decode(User.self, from: data)
                subscribtion.onNext(object)
                subscribtion.onCompleted()
            } catch {
                subscribtion.onError(error)
            }
            
            return Disposables.create()
        }
        // TODO: revert back temporarily replaced fetch call with mock object
//        return fetch(getUrl: URLString.user)
    }
    
    func fetchDribbbleShots() -> Observable<[Shot]> {
        let data = """
{
    "id": 0,
    "description": "description",
    "html_url": "https://cdn.dribbble.com/users/824641/screenshots/4773637",
    "title": "title",
    "images": {
        "normal": "https://cdn.dribbble.com/users/824641/screenshots/4773637/3dflip_teaser.gif"
    },
    "animated": true
}
""".data(using: .utf8)!
        
        return Observable<[Shot]>.create { subscribtion in
            do {
                let object = try JSONDecoder().decode(Shot.self, from: data)
                subscribtion.onNext((0..<4).map { _ in object })
                subscribtion.onCompleted()
            } catch {
                subscribtion.onError(error)
            }
            
            return Disposables.create()
        }
        // TODO: revert back temporarily replaced fetch call with mock object
//        return fetch(getUrl: URLString.shots, parametrs: ["per_page=200"])
    }
    
    private func fetch<T>(getUrl: String, parametrs: [String]? = nil) -> Observable<T> where T: Codable {
        return URLSession.shared.rx.dataWithRecallToken(getURL: getUrl, parametrs: parametrs)
            .flatMap { data -> Observable<T> in
                #if DEBUG
                if let json = try? JSONSerialization.jsonObject(with: data) { print(json) }
                #endif
                do {
                    let user = try JSONDecoder().decode(T.self, from: data)
                    return Observable.just(user)
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                    return Observable.empty()
                }
        }
    }
}
