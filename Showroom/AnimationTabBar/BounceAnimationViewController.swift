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

        // Do any additional setup after loading the view.
    }

  @IBAction func dismisHandler(_ sender: Any) {
    tabBarController?.dismiss(animated: true, completion: nil)
    
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
