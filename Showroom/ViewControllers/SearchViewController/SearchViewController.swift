import UIKit
import RAMReel
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
  
  
  let viewModel: ReelSearchViewModel
  var bag = DisposeBag()
  
  private var ramReel: RAMReel<RAMCell, UITextField, SimplePrefixQueryDataSource>!
  private let loadingOverlay = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
  
  init(viewModel: ReelSearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupReelSearch()
    setupLoadingIndicator()
    
    MenuPopUpViewController.showPopup(on: self, url: Showroom.Control.reelSearch.sharedURL) { [weak self] in
      self?.dismiss(animated: true, completion: nil)
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ThingersTapViewController.showPopup(on: self)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    loadingIndicator.center = loadingOverlay.center
  }
  
  private func setupReelSearch() {
//    viewModel.dataSource.asObservable()
//      .skip(1) // skip initial empty value
//      .observeOn(MainScheduler.instance)
//      .subscribe(onNext: { dataSource in
//        self.ramReel = RAMReel<RAMCell, UITextField, SimplePrefixQueryDataSource>(frame: self.view.bounds, dataSource: dataSource, placeholder: "Start by typing…", attemptToDodgeKeyboard: true) {
//          print("Plain:", $0)
//        }
//
//        self.ramReel.hooks.append {
//          let r = Array($0.reversed())
//          let j = String(r)
//          print("Reversed:", j)
//        }
//
//        self.view.addSubview(self.ramReel.view)
//        self.ramReel.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        self.hideOverlay(true)
//      })
//        .disposed(by: bag)
  }
  
  private func setupLoadingIndicator() {
    loadingOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    loadingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    loadingOverlay.frame = view.bounds
    view.addSubview(loadingOverlay)
    
    loadingIndicator.color = .white
    loadingIndicator.startAnimating()
    loadingIndicator.frame = loadingOverlay.bounds
    loadingOverlay.addSubview(loadingIndicator)
    loadingIndicator.center = loadingOverlay.center
  }
  
  private func hideOverlay(_ value: Bool = true) {
    UIView.animate(withDuration: 0.3) { 
      self.loadingOverlay.alpha = value ? 0 : 1
    }
  }
  
  override open var shouldAutorotate: Bool {
    return false
  }
}
