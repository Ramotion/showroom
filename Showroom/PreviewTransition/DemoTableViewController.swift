import UIKit
import PreviewTransition

public class DemoTableViewController: PTTableViewController {
  
  fileprivate let items = [("1", "River cruise"), ("2", "North Island"), ("3", "Mountain trail"), ("4", "Southern Coast"), ("5", "Fishing place")] // image names
}

// MARK: Life Cycle
extension DemoTableViewController {
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    addBackButton()
  }
  
}

// MARK: UITableViewDelegate
extension DemoTableViewController {
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? ParallaxCell else { return }
    
    let index = indexPath.row % items.count
    let imageName = items[index].0
    let title = items[index].1
    
    if let image = UIImage(named: imageName) {
      cell.setImage(image, title: title)
    }
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ParallaxCell = tableView.getReusableCellWithIdentifier(indexPath: indexPath)
    return cell
  }
  
  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyboard = UIStoryboard.storyboard(storyboard: .Main)
    let detaleViewController: DemoDetailViewController = storyboard.instantiateViewController()
    pushViewController(detaleViewController)
  }

}
