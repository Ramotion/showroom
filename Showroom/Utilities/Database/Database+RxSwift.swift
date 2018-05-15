import Foundation
import FirebaseDatabase
import RxSwift

private enum FirebaseKey {
    static let users = "shots"
    // TODO: Remove it before github
    static let secretKey = "Ldfkjtlsdf1235-45lj2DfdfCP-sf"
    
    enum FirebaseError: Error {
        case emptyData
        case wrongParse
    }
}

extension Reactive where Base: Database {
    
    func fetchShots() -> Observable<[FirebaseModel.Shot]> {
        return fetch(path: "shots")
    }
    
    private func fetch<T>(path: String) -> Observable<T> where T: Codable {
        return Observable.create { (observer) -> Disposable in
            Database.database().secureReference(withPath: path)
                .observeSingleEvent(of: .value, with: { snapshot in
                    print(snapshot)
                    guard let data = snapshot.value as? [[String: String]],
                        let json = try? JSONEncoder().encode(data) else {
                        observer.onError(FirebaseKey.FirebaseError.emptyData)
                        return
                    }
                    
                    #if DEBUG
                    print(json)
                    #endif
                    
                    do {
                        let item = try JSONDecoder().decode(T.self, from: json)
                        observer.onNext(item)
                        observer.onCompleted()
                    } catch {
                        #if DEBUG
                        print(error)
                        #endif
                        observer.onError(FirebaseKey.FirebaseError.wrongParse)
                    }
                    
            }, withCancel: { (error) in
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    func fetchReference(user: User) -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            let newUser = Database.database().reference().child("\(user.id)")
            newUser.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                   print(snapshot.value)
                    observer.onNext(newUser)
                    observer.onCompleted()
                } else {
                    print("empty state")
                    observer.onError(FirebaseKey.FirebaseError.emptyData)
                }
                
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    func save(user: User) -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            let newUser = Database.database().reference().child("\(user.id)")
            newUser.setValue(user.toDictionary) { (error, database) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(database)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func save(shot: Shot, userRef: DatabaseReference) -> Observable<DatabaseReference> {
        return Observable.create { (observer) -> Disposable in
            let shotsRef = userRef.child("shots").child("\(shot.id)")
            shotsRef.setValue(shot.toDictionary) { (error, database) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(database)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}


private extension Database {
    
    func secureReference(withPath: String) -> DatabaseQuery  {
//        return reference(withPath: withPath)
        return reference()
            .queryEqual(toValue: FirebaseKey.secretKey)
    }
}
