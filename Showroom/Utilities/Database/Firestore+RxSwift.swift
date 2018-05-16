import Foundation
import Firebase
import RxSwift

private enum FirebaseConstant {
    static let shots = "shots"
}

extension Reactive where Base: Firestore {
    
    func save(shot: Shot, user: User) -> Observable<()> {
        return Observable.create { (observer) -> Disposable in
            
            var shotDict = shot.toDictionary
            shotDict["userId"] = user.id
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
