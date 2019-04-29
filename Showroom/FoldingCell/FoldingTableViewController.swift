import UIKit

fileprivate struct C {
  
  static let count: Int = 4
  
  struct CellHeight {
    static let close: CGFloat = 179
    static let open: CGFloat = 488
  }
  
}
class FoldingTableViewController: UITableViewController {
  
  var cellHeight = (0..<C.count).map { _ in C.CellHeight.close }
  
  var preloadCells: [UITableViewCell]!
  
  let colors = [UIColor(red:0.35, green:0.29, blue:0.61, alpha:1.00),
                UIColor(red:0.32, green:0.64, blue:0.23, alpha:1.00),
                UIColor(red:0.97, green:0.67, blue:0.09, alpha:1.00)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    preloadCells = (0..<C.count).enumerated().map { (index, element) in
      let indexPath = IndexPath(row: index, section: 0)
      return tableView.dequeueReusableCell(withIdentifier: String(describing: DemoFoldginCell.self), for: indexPath)
    }
    
    MenuPopUpViewController.showPopup(on: self, url: Showroom.Control.circleMenu.sharedURL) { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    ThingersTapViewController.showPopup(on: self)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard case let cell as DemoFoldginCell = cell else { return }
    cell.setCellCollor(color: colors[indexPath.row % colors.count])
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return C.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return preloadCells[indexPath.row]
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeight[indexPath.row]
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath) as! DemoFoldginCell
    
    if cell.isAnimating() {
      return
    }
    
    var duration = 0.0
    let cellIsCollapsed = cellHeight[indexPath.row] == C.CellHeight.close
    if cellIsCollapsed {
      cellHeight[indexPath.row] = C.CellHeight.open
      cell.unfold(true, animated: true, completion: nil)
      duration = 0.5
    } else {
      cellHeight[indexPath.row] = C.CellHeight.close
      cell.unfold(false, animated: true, completion: nil)
      duration = 0.8
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
      tableView.beginUpdates()
      tableView.endUpdates()
    }, completion: nil)
  }
}
