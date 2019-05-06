//
//  BounceAnimationViewController.swift
//  Showroom
//
//  Created by Alex K. on 21/11/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class BounceAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

  @IBAction func dismisHandler(_ sender: Any) {
    tabBarController?.dismiss(animated: true, completion: nil)
    
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
