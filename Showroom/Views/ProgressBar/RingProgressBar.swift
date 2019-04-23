import UIKit

final class RingProgressBar: UIView {
    
    private var progressBarLayer = CAShapeLayer()
    
    init(radius: CGFloat, color: UIColor, lineWidth: CGFloat) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius),
                                      radius: radius - 1.5, startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        
        layer.addSublayer(progressBarLayer)
        progressBarLayer.path = circlePath.cgPath
        progressBarLayer.fillColor = UIColor.clear.cgColor
        progressBarLayer.strokeColor = color.cgColor
        progressBarLayer.lineWidth = lineWidth
        progressBarLayer.strokeEnd = 0
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Actions
    func start(duration: TimeInterval, value: Float, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock( { completion?() } )
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        progressBarLayer.strokeEnd = CGFloat(value)
        progressBarLayer.add(animation, forKey: "animateCircle")
        CATransaction.commit()
    }
    
}
