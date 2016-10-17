import UIKit

class MainViewController: UITableViewController {
  
  let items: [RAMControls.Control] = [.circleMenu,
                                      .foldingCell,
                                      .paperSwitch,
                                      .paperOnboarding,
                                      .expandingCollection,
                                      .previewTransition,
                                      .animationTabBar,
                                      .realSearch,
                                      .navigationStack]
}

// MARK: Configure
extension MainViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: UITableViewDatasource
extension MainViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: String(describing: ItemCell.self), for: indexPath)
  }
}

// MARK: UITableViewDelegate
extension MainViewController {
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard case let cell as ItemCell = cell else { return }
    
    cell.itemTitle.text = items[indexPath.row].name
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewController = items[indexPath.row].viewController
    switch items[indexPath.row] {
    case .navigationStack: present(viewController, animated: true, completion: nil)
    default : navigationController?.pushViewController(viewController, animated: true)

    }
  }
}
