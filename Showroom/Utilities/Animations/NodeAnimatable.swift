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


protocol NodeAnimatable {
  func animate(duration: TimeInterval, _ animations: [NodeAnimations], timing: NodeAnimatinos.Timing?, delay: TimeInterval?, completion: (() -> ())?)
}

extension NodeAnimatable where Self: UIView {
  
  func animate(duration: TimeInterval, _ animations: [NodeAnimations], timing: NodeAnimatinos.Timing? = nil, delay: TimeInterval? = nil, completion: (() -> ())? = nil) {
    
    if let completion = completion { startDelay(duration, completion) }
    
    for animation in animations {
      let animationObject = animation.createAnimation
      animationObject.duration = duration
      if let timing = timing { animationObject.timingFunction = timing.popTiming }
      if let delay = delay { animationObject.beginTime = CACurrentMediaTime() + delay }
      switch animation {
      case .alpha, .alphaFrom, .color, .layerPositionY: layer.pop_add(animationObject, forKey: nil)
      case .titleColor, .viewScale: pop_add(animationObject, forKey: nil)
      }
    }
  }
}

extension UIView: NodeAnimatable {}
