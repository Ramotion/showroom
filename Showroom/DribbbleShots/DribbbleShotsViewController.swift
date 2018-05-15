import UIKit
import OAuthSwift
import Nuke
import RxSwift
import FirebaseDatabase

final class DribbbleShotsViewController: UIViewController {
    
    fileprivate var networkingManager = NetworkingManager()
    fileprivate var user: User?
    fileprivate var userRef: DatabaseReference?
    
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

        fetchData()
        
        collectionView.rx
            .modelSelected(Shot.self)
            .subscribe(onNext: { shot in
                print(shot)
                
                let alertView = UIAlertController(title: "Do you want send this Shot", message: nil, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
                    if let user = self.user {
                        self.save(shot: shot, from: user, userRef: self.userRef)
                    }
                })
                UIViewController.current?.present(alertView, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
    // MARK: Actions
    @objc func doneHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    func save(shot: Shot, from user: User, userRef: DatabaseReference?) {
        if let userRef = userRef {
            Database.database().rx.save(shot: shot, userRef: userRef)
                .subscribe {
                    print($0)
                }
                .disposed(by: rx.disposeBag)
        } else {
            Database.database().rx.save(user: user)
                .flatMap({ userRef -> Observable<DatabaseReference> in
                    self.userRef = userRef
                    return Database.database().rx.save(shot: shot, userRef: userRef)
                })
                .subscribe {
                    print($0)
                }
                .disposed(by: rx.disposeBag)
        }
    }
}

// MARK: Helpers
private extension DribbbleShotsViewController {
    
    func fetchData() {
        
        // fetch user
        networkingManager.fetchDribbbleUser()
            .flatMap { user -> Observable<DatabaseReference> in
                self.user = user
                return Database.database().rx.fetchReference(user: user)
            }
            .subscribe {
                switch $0 {
                case .completed, .error: break // do nothing
                case .next(let userRef): self.userRef = userRef
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
    }
}
