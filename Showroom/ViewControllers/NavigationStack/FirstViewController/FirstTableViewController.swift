//
//  FirstTableViewController.swift
//  NavigationStackDemo
//
//  Created by Alex K. on 29/02/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Navigation_stack
// MARK: FirstTableViewController

class FirstTableViewController: UITableViewController {
  
  @IBOutlet var search: UISearchBar!
  var hideNavBar = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController!.interactivePopGestureRecognizer?.delegate = self
    
    navigationItem.titleView = search
    
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.isTranslucent = false
    
    MenuPopUpViewController.showPopup(on: self) { [weak self] in
      self?.hideNavBar = true
      self?.navigationController?.dismiss(animated: true, completion: nil)
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ThingersTapViewController.showPopup(on: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let navigationController = navigationController {
      navigationController.navigationBar.barTintColor = UIColor(red:0.4, green:0.47, blue:0.62, alpha:1)
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if hideNavBar == false { return }
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "push", sender: nil)
  }
  
  @IBAction func doneHandler(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: UIGestureRecognizerDelegate
extension FirstTableViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    
    if navigationController?.viewControllers.count == 2 {
      return true
    }
    
    if let navigationController = self.navigationController as? NavigationStack {
      navigationController.showControllers()
    }
    
    return false
  }
}
