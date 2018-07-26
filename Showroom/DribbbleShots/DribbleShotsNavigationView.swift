//
//  DribbleShotsNavigationView.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 26/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

private let kDribbleShotsNavigationViewHeight: CGFloat = 90

final class DribbleShotsNavigationView : UIView, NibLoadable {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private(set) var backButton: UIButton!
    
    // MARK: - Resizing Behaviour
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        
        size.height = kDribbleShotsNavigationViewHeight
        
        return size
    }
    
    // MARK: - Measuring in Auto Layout
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        size.height = kDribbleShotsNavigationViewHeight
        
        return size
    }
    
}
