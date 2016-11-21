import UIKit

fileprivate struct C {
  
  static let count = 9
  
  struct CellHeight {
    static let close: CGFloat = 179
    static let open: CGFloat = 488
  }
}
class FoldingTableViewController: UITableViewController {
  
  var cellHeight = (0..<C.count).map { _ in C.CellHeight.close }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    addBackButton()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return C.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: String(describing: DemoFoldginCell.self), for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeight[indexPath.row]
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? DemoFoldginCell else {
      return
    }
    
    var duration = 0.0
    if cellHeight[indexPath.row] == C.CellHeight.close { // open cell
      cellHeight[indexPath.row] = C.CellHeight.open
      cell.selectedAnimation(true, animated: true, completion: nil)
      duration = 0.5
    } else {// close cell
      cellHeight[indexPath.row] = C.CellHeight.close
      cell.selectedAnimation(false, animated: true, completion: nil)
      duration = 1.1
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
      tableView.beginUpdates()
      tableView.endUpdates()
      }, completion: nil)
  }
}
