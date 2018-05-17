import UIKit
import OAuthSwift
import Nuke
import RxSwift
import Firebase

final class DribbbleShotsViewController: UIViewController {
    
    fileprivate var networkingManager = NetworkingManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
}

// MARK: Life Cycle
extension DribbbleShotsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize nav bar
        title = "Dribbble Shots"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneHandler))
        navigationItem.leftBarButtonItem = doneButton

        // customze collection
        collectionView.register(DribbbleShotCell.self)
        let margins = collectionView.layoutMargins.left + collectionView.layoutMargins.right
        let itemWidth = (UIScreen.main.bounds.size.width - margins) / 2 - 14
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: itemWidth, height: itemWidth)

        let userSignal = fetchData()
        
        collectionView.rx
            .modelSelected(Shot.self)
            .withLatestFrom(userSignal, resultSelector: { return ($0, $1) })
            .flatMap { param -> Observable<(Shot, User)> in
                return UIAlertController(title: nil, message: "Do you want send this Shot", preferredStyle: .alert)
                    .confirmation()
                    .withLatestFrom(Observable.just(param))
            }
            .flatMap { (shot, user) -> Observable<Void> in
                return Firestore.firestore().rx.save(shot: shot, user: user)
            }
            .subscribe {
                switch $0 {
                case .completed: break
                case .error(let error): print("save error: \(error)")
                default: break // do nothing
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    // MARK: Actions
    @objc func doneHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    func save(shot: Shot, user: User) {
        Firestore.firestore().rx.save(shot: shot, user: user)
            .subscribe {
                switch $0 {
                case .completed: print("success")
                case .error(let error): print(error)
                default: break // do nothing
                }
            }.disposed(by: rx.disposeBag)
    }
}

// MARK: Helpers
private extension DribbbleShotsViewController {
    
    func fetchData() -> Observable<User> {
        
        let userSignal = networkingManager.fetchDribbbleUser()
        
        userSignal
            .flatMap { return Firestore.firestore().rx.fetchShots(from: $0) }
            .subscribe {
                switch $0 {
                case .completed: break
                case .error(let error): print(error)
                case .next(let shots): print(shots)
                }
            }
            .disposed(by: rx.disposeBag)

        networkingManager.fetchDribbbleShots()
            .catchErrorJustReturn([])
            .map { $0.filter { shot in shot.animated } }
            .bind(to: collectionView.rx.items(cellIdentifier: "Shot", cellType: DribbbleShotCell.self)) { row, element, cell in
                cell.nameLabel.text = element.title
                if let url = element.imageUrl { Manager.shared.loadImage(with: url, into: cell.imageView) }
            }
            .disposed(by: rx.disposeBag)
        
        return userSignal
    }
}
