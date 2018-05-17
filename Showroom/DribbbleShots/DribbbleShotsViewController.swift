import UIKit
import OAuthSwift
import Nuke
import RxSwift
import Firebase

final class DribbbleShotsViewController: UIViewController {
    
    typealias Item = (user: Shot, sended: Bool)
    
    fileprivate let networkingManager: NetworkingManager
    fileprivate let userSignal: Observable<User>
    fileprivate let dribbbleShotsSignal: Observable<[Shot]>
    
    fileprivate let reloadData = Variable<[Item]>([])
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        let network = NetworkingManager()
        self.networkingManager = network
        self.userSignal = network.fetchDribbbleUser()
        
        self.dribbbleShotsSignal = network.fetchDribbbleShots()
            .catchErrorJustReturn([])
            .map { $0.filter { shot in shot.animated } }
        
        super.init(coder: aDecoder)
    }
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

        fetchData(userSignal: userSignal, dribbbleShotsSignal: dribbbleShotsSignal)
        
        reloadData.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "Shot", cellType: DribbbleShotCell.self)) { row, element, cell in
                let (shot, selected) = element
                cell.nameLabel.text = shot.title
                if let url = shot.imageUrl { Manager.shared.loadImage(with: url, into: cell.imageView) }
                
                cell.imageView.alpha = selected ? 0.3 : 1
            }
            .disposed(by: rx.disposeBag)
        
        collectionView.rx
            .modelSelected((Shot, Bool).self)
            .flatMap({ (shot, selected) -> Observable<Shot> in
                return selected ? Observable.empty() : Observable.just(shot)
            })
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
                case .next: self.fetchData(userSignal: self.userSignal, dribbbleShotsSignal: self.dribbbleShotsSignal)
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
    
    func fetchData(userSignal: Observable<User>, dribbbleShotsSignal: Observable<[Shot]>) {
        
        let sendedShotsSignal = userSignal.flatMap { return Firestore.firestore().rx.fetchShots(from: $0) }
            .catchErrorJustReturn([])
        
        Observable.zip(dribbbleShotsSignal, sendedShotsSignal) { return ($0, $1) }
            .map { (dribbbleShots, sendedShots) -> [(Shot, Bool)] in // shot, selected
                let sendedShotIds = sendedShots.map { $0.id }
                return dribbbleShots.map { ($0, sendedShotIds.contains($0.id)) }
            }
            .subscribe({
                if let items = $0.element {
                    self.reloadData.value = items
                }
            })
            .disposed(by: rx.disposeBag)
    }
}
