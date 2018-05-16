import Foundation
import FirebaseDatabase
import RxSwift

private enum FirebaseKey {
    static let shots = "shots"

    enum FirebaseError: Error {
        case emptyData
        case wrongParse
    }
}

extension Reactive where Base: Database {
    
    func fetchShots(user: User) -> Observable<[FirebaseModel.Shot]> {
        let shotsRef = Database.database().reference().child("\(user.id)").child(FirebaseKey.shots)
        return fetch(reference: shotsRef)
    }
    
    private func fetch<T>(reference: DatabaseReference) -> Observable<T> where T: Codable {
        return Observable.create { (observer) -> Disposable in
            reference
                .observeSingleEvent(of: .value, with: { snapshot in
                    print(snapshot)
                    guard let dict = snapshot.value as? [String: [String: String]] else {
                        observer.onError(FirebaseKey.FirebaseError.emptyData)
                        return
                    }

                    #if DEBUG
                    print(dict)
                    #endif

                    do {
                        let array = dict.compactMap { return $1 }
                        let json: Data? = try? JSONEncoder().encode(array)
                        let item = try JSONDecoder().decode(T.self, from: json!)
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
            let shotsRef = userRef.child(FirebaseKey.shots).child("\(shot.id)")
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
