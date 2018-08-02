//
//  DribbbleShotImageView.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 05/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

class DribbbleShotImageView: UIImageView {

    private var overlayView = UIView()
    
    // MARK: - Initialization
    
    var isTransparentOverlayVisible: Bool = false {
        didSet {
            if isTransparentOverlayVisible {
                overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                overlayView.frame = bounds
                overlayView.backgroundColor = UIColor(white: 1, alpha: 0.3)
                addSubview(overlayView)
            } else {
                overlayView.removeFromSuperview()
            }
        }
    }

}
