import UIKit
import pop

struct NodeAnimatinos {
  
  enum Timing {
    case defaultTiming
    case linear
    case easyIn
    case easyOut
    case easyInEasyOut
  }
}

private extension NodeAnimatinos.Timing {
  
  var popTiming: CAMediaTimingFunction {
    switch self {
    case .defaultTiming: return CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
    case .linear: return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear) 
    case .easyIn: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) 
    case .easyOut: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    case .easyInEasyOut: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    }
  }
}


protocol NodeAnimatable: class {
  func animate(duration: TimeInterval, delay: TimeInterval?, _ animations: [NodeAnimations], timing: NodeAnimatinos.Timing?, completion: (() -> ())?)
}

extension NodeAnimatable where Self: UIView {
  
  func animate(duration: TimeInterval,
               delay: TimeInterval? = nil,
               _ animations: [NodeAnimations],
               timing: NodeAnimatinos.Timing? = nil,
               completion: (() -> ())? = nil) {
    
    if let completion = completion { startDelay(duration + (delay ?? 0), completion) }
    
    for animation in animations {
      let animationObject = animation.createAnimation
      
      if case let animationObject as POPBasicAnimation = animationObject {
        animationObject.duration = duration
        if let timing = timing { animationObject.timingFunction = timing.popTiming }
      }
      
      if let delay = delay { animationObject.beginTime = CACurrentMediaTime() + delay }
      switch animation {
      case .color, .layerPositionY, .layerPositionXY, .layerPositionX, .springScale, .layerScale: layer.pop_add(animationObject, forKey: nil)
      case .alpha, .alphaFrom, .titleColor, .viewScale: pop_add(animationObject, forKey: nil)
      }
    }
  }
}

extension UIView: NodeAnimatable {}
