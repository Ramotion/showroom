import UIKit
import OAuthSwift
import RxSwift
//import RxCocoa
import Firebase
import MBProgressHUD

final class DribbbleShotsViewController: UIViewController, DribbbleShotsTransitionDestination {
    
    fileprivate let networkingManager = NetworkingManager()
    fileprivate let userSignal: Observable<User>
    fileprivate let dribbbleShotsSignal: Observable<[Shot]>
    
//    fileprivate let reloadData = BehaviorRelay<[DribbbleShotState]>(value: [])
    fileprivate let reloadData = Variable<[DribbbleShotState]>([])
    private var collectionViewLayout: DribbbleShotsCollectionViewLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private var backgroundView: UIView!
    private let navigationView = DribbleShotsNavigationView.loadFromNib()!
    private let fakeCollectionViewData = Variable<[DribbbleShotState]>((0..<8).map { _ in .wireframe })
    private let fakeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: DribbbleShotsCollectionViewLayout())
    
    required init?(coder aDecoder: NSCoder) {
        
        userSignal = networkingManager.fetchDribbbleUser()
        
        dribbbleShotsSignal = networkingManager.fetchDribbbleShots()
            .catchErrorJustReturn([])
            .map { $0.filter { shot in shot.animated } }
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Responding to View Events
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !collectionViewItemsDidAnimate {
            animateCollectionViewItemsInPlace {
                self.collectionViewItemsDidAnimate = true
            }
        }
    }
    
    @objc
    private dynamic var collectionViewItemsDidAnimate = false
    
    private func animateCollectionViewItemsInPlace(completion: @escaping () -> ()) {
        // add fake collection view above real collection view to animate wireframes
        // and then remove it from view hierarchy
        fakeCollectionView.registerNib(DribbbleShotCell.self)
        fakeCollectionView.isUserInteractionEnabled = false
        fakeCollectionView.backgroundColor = view.backgroundColor
        fakeCollectionView.frame = view.bounds
        fakeCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fakeCollectionViewData
            .asObservable()
            .bind(to: fakeCollectionView
            .rx
            .items(cellIdentifier: String(describing: DribbbleShotCell.self), cellType: DribbbleShotCell.self)) { row, element, cell in
                cell.state = element
            }
            .disposed(by: rx.disposeBag)
        view.insertSubview(fakeCollectionView, aboveSubview: collectionView)
    
        // force collection view cells to be inserted into the view hierarchy
        view.layoutIfNeeded()
    
        // animate
        (fakeCollectionView.collectionViewLayout as? DribbbleShotsCollectionViewLayout)?.animateItemsInPlace(completion: completion)
    }
    
    private func animateTransitionFromFakeCollectionViewToRealCollectionView(completion: (() -> ())? = nil) {
        guard fakeCollectionView.superview != nil else {
            completion?()
            return
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: { [weak self] in
            self?.fakeCollectionView.alpha = 0
        }, completion: { [weak self] _ in
            self?.fakeCollectionView.removeFromSuperview()
            completion?()
        })
    }
    
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
        collectionView.registerNib(DribbbleShotCell.self)
        collectionView.backgroundView = backgroundView
        collectionView.backgroundView?.isHidden = true
        
        // customize layout
        let layout = DribbbleShotsCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionViewLayout = layout
        
        fetchData(userSignal: userSignal, dribbbleShotsSignal: dribbbleShotsSignal)
        
        let reloadDataSignal = reloadData.asObservable()
        reloadDataSignal
            .bind(to: collectionView
            .rx
            .items(cellIdentifier: String(describing: DribbbleShotCell.self), cellType: DribbbleShotCell.self)
                    ) { row, element, cell in cell.state = element }
            .disposed(by: rx.disposeBag)
        
        reloadDataSignal.subscribe { [weak self] _ in
            self?.updateNavigationView()
        }
        .disposed(by: rx.disposeBag)
        
        // MARK: Item did select
        collectionView
            .rx
            .modelSelected(DribbbleShotState.self)
            .flatMap({ item -> Observable<Shot> in
                switch item {
                case .default(let shot):
                    return Observable.just(shot)
                case .sent (let shot):
                    return Observable.just(shot)
                case .wireframe:
                    return Observable.empty()
                }
            })
            .withLatestFrom(userSignal, resultSelector: { return ($0, $1) })
            .flatMap {[weak self] param -> Observable<(Shot, User, String)> in
                let confirmationVC = DribbbleShotsConfirmVC()
                confirmationVC.imageUrl = param.0.imageUrl
                confirmationVC.title = param.0.description ?? ""
                confirmationVC.transitioningDelegate = self!
                self?.present(confirmationVC, animated: true, completion: nil)
                return confirmationVC.create()
                    .withLatestFrom(Observable.just(param)) { message, shotInfo in (shotInfo.0, shotInfo.1, message) }
            }
            .flatMap { (shot, user, message) -> Observable<Void> in
                return Firestore.firestore().rx.save(shot: shot, user: user, message: message)
            }
            .subscribe(
                // Fix completion. onCompleted called after saving shot into firestore and saving must be called when button tapped.
                onNext: { [weak self] in
                    print("Next")
                    self!.fetchData(userSignal: self!.userSignal, dribbbleShotsSignal: self!.dribbbleShotsSignal)
                    if let topController = UIApplication.getTopMostViewController() { topController.dismiss(animated: true, completion: nil) }
            },
                onError: { error in
                    UIAlertController.show(message: "Can't send shot!")
            },
                onCompleted: {
                    print("completed")
//                    if let topController = UIApplication.getTopMostViewController() { topController.dismiss(animated: true, completion: nil) }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func updateNavigationView() {
        let numberOfElements = reloadData.value.count
        if numberOfElements == 0 {
            collectionView.backgroundView?.isHidden = false
            navigationView.backgroundColor = .clear
        } else {
            collectionView.backgroundView?.isHidden = true
            navigationView.backgroundColor = view.backgroundColor?.withAlphaComponent(0.90)
        }
    }
    
    // MARK: Actions
    @objc private func doneHandler() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Helpers
private extension DribbbleShotsViewController {
    
    func fetchData(userSignal: Observable<User>, dribbbleShotsSignal: Observable<[Shot]>) {
        let sendedShotsSignal = userSignal.flatMap { return Firestore.firestore().rx.fetchShots(from: $0) }
            .catchErrorJustReturn([])
        
        let collectionViewItemsAnimationDidFinish = rx.observe(Bool.self, "collectionViewItemsDidAnimate")
            .filter { $0 == true }
        
        Observable.zip(dribbbleShotsSignal, sendedShotsSignal, collectionViewItemsAnimationDidFinish)
            .map { (dribbbleShots, sendedShots, animationDidFinish) -> [(Shot, Bool)] in // shot, selected
                let sendedShotIds = sendedShots.map { $0.id }
                return dribbbleShots.map { ($0, sendedShotIds.contains($0.id)) }
            }
            .subscribe({ [weak self] in
                self?.reloadData.value = $0.element?.map { DribbbleShotState(shot: $0.0, sent: true) } ?? []
                self?.animateTransitionFromFakeCollectionViewToRealCollectionView(completion: nil)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension DribbbleShotsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return ZoomAnimateController(originFrame: CGRect(x: view.bounds.width / 2 - 65, y: view.bounds.height / 2 - 65, width: 130, height: 130), direction: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            guard let _ = dismissed as? DribbbleShotsConfirmVC else { return nil }
            return ZoomAnimateController(originFrame: CGRect(x: view.bounds.width / 2 - 65, y: view.bounds.height / 2 - 65, width: 130, height: 130), direction: .dismissing)
    }
}
