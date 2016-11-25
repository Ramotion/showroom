import UIKit
import pop

protocol NodeAnimatable {
    func animate(duration: TimeInterval, _ animations: [NodeAnimations], completion: (() -> ())?)
}

extension NodeAnimatable where Self: UIView {
    
    func animate(duration: TimeInterval, _ animations: [NodeAnimations], completion: (() -> ())? = nil) {
        
        if let completion = completion {
            delay(duration, completion)
        }
        
        for animation in animations {
            let animationObject = animation.createAnimation
            animationObject.duration = duration
            switch animation {
            case .alpha, .alphaFrom, .color: layer.pop_add(animationObject, forKey: nil)
            case .titleColor: pop_add(animationObject, forKey: nil)
            }
        }
    }
}

extension UIView: NodeAnimatable {}
