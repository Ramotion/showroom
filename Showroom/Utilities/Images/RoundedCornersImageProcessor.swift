//
//  RoundedCornersImageProcessor.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 02/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import Foundation
import Nuke

public struct RoundedCornersImageProcessor: Processing {

    public let radius: CGFloat
    
    public init(radius: CGFloat) {
        self.radius = radius
    }
    
    public func process(_ image: Image) -> Image? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        let clippingPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: image.size), cornerRadius: radius)
        clippingPath.addClip()
        
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
}
