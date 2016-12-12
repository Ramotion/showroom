import UIKit
import PreviewTransition

class DemoTableViewController: PTTableViewController {
  
  fileprivate let items = [("1", "River cruise"), ("2", "North Island"), ("3", "Mountain trail"), ("4", "Southern Coast"), ("5", "Fishing place")] // image names
}

// MARK: Life Cycle
extension DemoTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MenuPopUpViewController.showPopup(on: self) { [weak self] in
      self?.navigationController?.dismiss(animated: true, completion: nil)
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ThingersTapViewController.showPopup(on: self)
  }
  
}

// MARK: UITableViewDelegate
extension DemoTableViewController {
  
//  override var prefersStatusBarHidden: Bool {
//    return false
//  }
  
//  override func prefersStatusBarHidden() -> Bool {
//    return true
//  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ParallaxCell else { return }
    cell.isMultipleTouchEnabled = false
    
    let index = indexPath.row % items.count
    let imageName = items[index].0
    let title = items[index].1
    
    if let image = UIImage(named: imageName) {
      cell.setImage(image, title: title)
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ParallaxCell = tableView.getReusableCellWithIdentifier(indexPath: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyboard = UIStoryboard.storyboard(storyboard: .Main)
    let detaleViewController: DemoDetailViewController = storyboard.instantiateViewController()
    pushViewController(detaleViewController)
  }
}
