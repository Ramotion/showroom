import UIKit
import RAMReel

class SearchViewController: UIViewController {
  
  var dataSource: SimplePrefixQueryDataSource!
  var ramReel: RAMReel<RAMCell, RAMTextField, SimplePrefixQueryDataSource>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = SimplePrefixQueryDataSource(data)
    ramReel = RAMReel(frame: self.view.bounds, dataSource: dataSource, placeholder: "Start by typing…") {
      print("Plain:", $0)
    }
    ramReel.hooks.append {
      let r = Array($0.characters.reversed())
      let j = String(r)
      print("Reversed:", j)
    }
    
    self.view.addSubview(ramReel.view)
    ramReel.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    addBackButton()
  }
  
  
  fileprivate let data: [String] = {
    do {
      guard let dataPath = Bundle.main.path(forResource: "data", ofType: "txt") else {
        return []
      }
      
      let data = try WordReader(filepath: dataPath)
      return data.words
    }
    catch let error {
      print(error)
      return []
    }
  }()
}
