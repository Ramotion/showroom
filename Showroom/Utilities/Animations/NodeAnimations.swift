import UIKit
import pop

enum NodeAnimations {
  case alphaFrom(CGFloat, to: CGFloat)
  case alpha(to: CGFloat)
  case color(to: UIColor)
  case titleColor(to: UIColor) // only for UILabel
  case viewScale(from: CGFloat, to: CGFloat)
  case layerPositionY(from: CGFloat, to: CGFloat)
}

extension NodeAnimations {
  
  var createAnimation: POPBasicAnimation {
    switch self {
    case .alphaFrom(let from, let to): return createPopAlphaAnimation(from, to: to)
    case .alpha(let to): return createPopAlphaAnimation(nil, to: to)
    case .color(let to): return createPopColorAnimation(to)
    case .titleColor(let to): return createPopTitleColorAnimation(to)
    case .viewScale(let from, let to): return createPopViewScaleAnimation(from: from, to: to)
    case .layerPositionY(let from, let to): return createPopLayerYAnimation(from: from, to: to)
    }
  }
}
