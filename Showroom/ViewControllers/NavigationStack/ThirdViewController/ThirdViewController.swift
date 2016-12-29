//
//  ThirdViewController.swift
//  NavigationStackDemo
//
//  Created by Alex K. on 29/02/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class ThirdViewController: UITableViewController {
  
  var hideNavBar = false
  
  @IBInspectable var navbarColor: UIColor = .black
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if hideNavBar == false { return }
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }
  
  @IBAction func backHandler(_ sender: AnyObject) {
    let _ = navigationController?.popViewController(animated: true)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "push", sender: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    _ = MenuPopUpViewController.showPopup(on: self, url: "https://github.com/Ramotion/navigation-stack") { [weak self] in
      self?.hideNavBar = true
      self?.navigationController?.dismiss(animated: true, completion: nil)
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  override open var shouldAutorotate: Bool {
    return false
  }
}
