import Foundation
import OAuthSwift
import RxSwift
import SafariServices

final class NetworkingManager {
    
    enum URLString {
        static let base = "https://api.dribbble.com/v2/"
        static let user = base + "user"
        static let shots = base + "user/shots"
        static let popularShots = base + "popular_shots"
    }
}

// MARK: Methods
extension NetworkingManager {
    
    func fetchDribbbleUser() -> Observable<User> {
        return fetch(getUrl: URLString.user)
    }

    func fetchDribbblePopularShots() -> Observable<[Shot]> {
        let request = URLRequest(url: URL(string: URLString.popularShots)!)
        return URLSession.shared.rx
            .data(request: request)
            .map { try JSONDecoder().decode([Shot].self, from: $0) }
    }
    
    func fetchDribbbleShots() -> Observable<[Shot]> {
        return fetch(getUrl: URLString.shots, parametrs: ["per_page=200"])
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
