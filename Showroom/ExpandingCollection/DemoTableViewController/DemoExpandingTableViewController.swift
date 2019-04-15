import UIKit
import expanding_collection

class DemoExpandingTableViewController: ExpandingTableViewController {
  
  fileprivate var scrollOffsetY: CGFloat = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavBar()
    let image1 = UIImage(named: "BackgroundImage")
    tableView.backgroundView = UIImageView(image: image1)
    
    if #available(iOS 11.0, *) {
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    MenuPopUpViewController.showPopup(on: self, url: "https://github.com/Ramotion/circle-menu") { [weak self] in
      self?.navigationController?.dismiss(animated: true, completion: nil)
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  override open var shouldAutorotate: Bool {
    return false
  }
}
// MARK: Helpers

extension DemoExpandingTableViewController {
  
  fileprivate func configureNavBar() {
    navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
  }
}

// MARK: Actions

extension DemoExpandingTableViewController {
  
  @IBAction func backButtonHandler(_ sender: AnyObject) {
    // buttonAnimation
    let viewControllers: [DemoExpandingViewController?] = navigationController?.viewControllers.map { $0 as? DemoExpandingViewController } ?? []

    for viewController in viewControllers {
      if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(false)
      }
    }
    popTransitionAnimation()
  }
}

// MARK: UIScrollViewDelegate

extension DemoExpandingTableViewController {
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollOffsetY = scrollView.contentOffset.y
  }
}
