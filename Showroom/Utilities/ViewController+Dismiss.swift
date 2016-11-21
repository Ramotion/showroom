import Foundation
import UIKit

protocol UIViewControllerDismissble {
  
  func addBackButton() 
}

extension UIViewController: UIViewControllerDismissble {
  
  func addBackButton() {
    
    let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissController))
    navigationItem.leftBarButtonItem = button
  }
  
  func dismissController() {
    
    navigationController?.dismiss(animated: true, completion: nil)
  }
}
