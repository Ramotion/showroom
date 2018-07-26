import UIKit
import OAuthSwift
import RxSwift
import Firebase
import MBProgressHUD

final class DribbbleShotsViewController: UIViewController, DribbbleShotsTransitionDestination {
    
    fileprivate let networkingManager: NetworkingManager
    fileprivate let userSignal: Observable<User>
    fileprivate let dribbbleShotsSignal: Observable<[Shot]>
    
    fileprivate let reloadData = Variable<[DribbbleShotState]>([.wireframe, .wireframe, .wireframe, .wireframe, .wireframe, .wireframe])
    private var collectionViewLayout: DribbbleShotsCollectionViewLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private var backgroundView: UIView!
    private let navigationView = DribbleShotsNavigationView.loadFromNib()!
    
    required init?(coder aDecoder: NSCoder) {
        let network = NetworkingManager()
        self.networkingManager = network
        self.userSignal = network.fetchDribbbleUser()
        
        self.dribbbleShotsSignal = network.fetchDribbbleShots()
            .catchErrorJustReturn([])
            .map { $0.filter { shot in shot.animated } }
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !collectionViewItemsDidAnimate {
            collectionViewLayout.animateItemsInPlace(completion: { [weak self] in
                self?.collectionViewItemsDidAnimate = true
            })
        }
    }
    
    private var collectionViewItemsDidAnimate = false
    
}

// MARK: Life Cycle
extension DribbbleShotsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation view
        navigationView.autoresizingMask = .flexibleWidth
        navigationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 0)
        navigationView.sizeToFit()
        navigationView.backButton.addTarget(self, action: #selector(doneHandler), for: .touchUpInside)
        view.addSubview(navigationView)
        updateNavigationView()
        
        // customize collection
        collectionView.register(DribbbleShotCell.self)
        collectionView.backgroundView = backgroundView
        collectionView.backgroundView?.isHidden = true
        
        // customize layout
        let layout = DribbbleShotsCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionViewLayout = layout
            
        fetchData(userSignal: userSignal, dribbbleShotsSignal: dribbbleShotsSignal)
        
        let reloadDataSignal = reloadData.asObservable()
        reloadDataSignal
            .bind(to: collectionView.rx.items(cellIdentifier: "Shot", cellType: DribbbleShotCell.self)) { row, element, cell in
                cell.state = element
            }
            .disposed(by: rx.disposeBag)
        
        reloadDataSignal.subscribe { [weak self] _ in
            self?.updateNavigationView()
        }
        .disposed(by: rx.disposeBag)
        
        // MARK: Item did select
        collectionView.rx
            .modelSelected(DribbbleShotState.self)
            .flatMap({ item -> Observable<Shot> in
                switch item {
                case .default(let shot): return Observable.just(shot)
                case .sent: return Observable.empty()
                case .wireframe: return Observable.empty()
                }
                
            })
            .withLatestFrom(userSignal, resultSelector: { return ($0, $1) })
            .flatMap { param -> Observable<(Shot, User, String)> in
                return UIAlertController.confirmation(message: "Do you want send this shot?")
                    .withLatestFrom(Observable.just(param)) { message, shotInfo in (shotInfo.0, shotInfo.1, message) }
            }
            .flatMap { [weak self] (shot, user, message) -> Observable<Void> in
                if let `self` = self { MBProgressHUD.showAdded(to: self.view, animated: true) }
                return Firestore.firestore().rx.save(shot: shot, user: user, message: message)
            }
            .subscribe { [weak self] in
                guard let `self` = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch $0 {
                case .completed: break
                case .error: UIAlertController.show(message: "Can't send shot!")
                case .next: self.fetchData(userSignal: self.userSignal, dribbbleShotsSignal: self.dribbbleShotsSignal)
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    private func updateNavigationView() {
        let numberOfElements = reloadData.value.count
        if numberOfElements == 0 {
            collectionView.backgroundView?.isHidden = false
            navigationView.backgroundColor = .clear
        } else {
            collectionView.backgroundView?.isHidden = true
            navigationView.backgroundColor = collectionView.backgroundColor?.withAlphaComponent(0.8)
        }
    }
    
    // MARK: Actions
    @objc func doneHandler() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Helpers
private extension DribbbleShotsViewController {
    
    func fetchData(userSignal: Observable<User>, dribbbleShotsSignal: Observable<[Shot]>) {
        
        let sendedShotsSignal = userSignal.flatMap { return Firestore.firestore().rx.fetchShots(from: $0) }
            .catchErrorJustReturn([])
        
        let collectionViewAnimationDidFinish = collectionViewLayout.rx.observe(DribbbleShotsCollectionViewLayout.AnimationState.self, "animationState")
            .filter { $0 == .finished }

        Observable.zip(dribbbleShotsSignal, sendedShotsSignal, collectionViewAnimationDidFinish)
            .map { (dribbbleShots, sendedShots, animationDidFinish) -> [(Shot, Bool)] in // shot, selected
                let sendedShotIds = sendedShots.map { $0.id }
                return dribbbleShots.map { ($0, sendedShotIds.contains($0.id)) }
            }
            .subscribe({ [weak self] in
                if let items = $0.element {
                    self?.reloadData.value = items.map { DribbbleShotState(shot: $0.0, sent: true) }
                }
            })
            .disposed(by: rx.disposeBag)
    }
}
