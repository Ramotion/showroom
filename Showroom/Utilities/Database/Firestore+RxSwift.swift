import Foundation
import Firebase
import RxSwift

private enum FirebaseConstant {
    static let shots = "shots"
    static let userId = "userId"
    static let message = "message"

    enum FirebaseError: Error {
        case emptyData
        case wrongParse
    }
}

extension Reactive where Base: Firestore {
    
    func save(shot: Shot, user: User, message: String) -> Observable<()> {
        return Observable.create { (observer) -> Disposable in
            
            var shotDict = shot.toDictionary
            shotDict[FirebaseConstant.userId] = user.id
            if !message.isEmpty { shotDict[FirebaseConstant.message] = message }
            Firestore.dbWithTimestamp
                .collection(FirebaseConstant.shots)
                .addDocument(data: shotDict) {
                    if let error = $0 {
                        observer.onError(error)
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
            }
            return Disposables.create()
        }
    }
    
    func fetchShots(from user: User) -> Observable<[FirebaseModel.Shot]> {
        return Observable.create({ (observer) -> Disposable in
            Firestore.dbWithTimestamp
                .collection(FirebaseConstant.shots)
                .whereField(FirebaseConstant.userId, isEqualTo: user.id)
                .getDocuments(completion: { (snapshot, error) in
                    if let error = error {
                       observer.onError(error)
                    } else {
                        guard let snapshot = snapshot else {
                            observer.onError(FirebaseConstant.FirebaseError.emptyData)
                            return
                        }
                        let shots = snapshot.documents.compactMap {
                           return try? JSONSerialization.data(withJSONObject: $0.data(), options: .prettyPrinted)
                        }
                        .compactMap {
                            return try? JSONDecoder().decode(FirebaseModel.Shot.self, from: $0)
                        }
                        observer.onNext(shots)
                        observer.onCompleted()
                    }
                })
            return Disposables.create()
        })
    }
}

private extension Firestore {
    
    static var dbWithTimestamp: Firestore {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }
}
