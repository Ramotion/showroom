//
//  DribbbleShotsBackgroundView.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 04/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

class DribbbleShotsBackgroundView: UIView {

    private var topShape: CAShapeLayer?
    private var bottomShape: CAShapeLayer?
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fillColor = UIColor(white: 1, alpha: 0.1)
        let yLess: CGFloat = 70
        let yMore: CGFloat = 151
        
        do {
            topShape?.removeFromSuperlayer()
            let shape = CAShapeLayer()
            shape.fillColor = fillColor.cgColor
            let path = UIBezierPath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: yLess))
            path.addLine(to: CGPoint(x: 0, y: yMore))
            path.close()
            shape.path = path.cgPath
            layer.addSublayer(shape)
            topShape = shape
        }
        
        do {
            bottomShape?.removeFromSuperlayer()
            let shape = CAShapeLayer()
            shape.fillColor = fillColor.cgColor
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - yMore))
            path.addLine(to: CGPoint(x: 0, y: bounds.height - yLess))
            path.close()
            shape.path = path.cgPath
            layer.addSublayer(shape)
            bottomShape = shape
        }
    }

}
