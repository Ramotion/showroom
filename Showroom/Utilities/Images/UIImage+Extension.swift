//
//  UIImage+Extension.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 11/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Creates image with specified size using block for drawing content
    public static func image(size: CGSize, actions: (UIGraphicsImageRendererContext) -> Void) -> UIImage {
        let format: UIGraphicsImageRendererFormat
        if #available(iOS 11.0, *) {
            format = UIGraphicsImageRendererFormat.preferred()
        } else {
            format = UIGraphicsImageRendererFormat.default()
        }
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image(actions: actions)
    }
    
}
