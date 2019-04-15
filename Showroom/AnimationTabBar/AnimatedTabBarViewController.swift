//
//  AnimatedTabBarViewController.swift
//  Showroom
//
//  Created by Abdurahim Jauzee on 23/05/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class AnimatedTabBarViewController: RAMAnimatedTabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    MenuPopUpViewController.showPopup(on: self, url: Showroom.Control.animationTabBar.sharedURL) { [weak self] in
      self?.dismiss(animated: true, completion: nil)
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ThingersTapViewController.showPopup(on: self)
  }
  
}
