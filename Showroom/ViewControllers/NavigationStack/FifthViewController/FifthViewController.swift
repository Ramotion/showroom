//
//  FifthViewController.swift
//  NavigationStackDemo
//
//  Created by Alex K. on 29/02/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class FifthViewController: UITableViewController {
  
  var hideNavBar = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    MenuPopUpViewController.showPopup(on: self, url: "https://github.com/Ramotion/navigation-stack") { [weak self] in
      self?.hideNavBar = true
      self?.navigationController?.dismiss(animated: true, completion: nil)
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
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
}
