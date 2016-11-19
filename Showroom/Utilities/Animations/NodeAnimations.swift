import UIKit
import pop

enum NodeAnimations {
    case alpha(from: CGFloat, to: CGFloat)
    case color(to: UIColor)
    case titleColor(to: UIColor) // only for UILabel
}

extension NodeAnimations {
    
    var createAnimation: POPBasicAnimation {
        switch self {
        case .alpha(let from, let to): return createPopAlphaAnimation(from, to: to)
        case .color(let to): return createPopColorAnimation(to)
        case .titleColor(let to): return createPopTitleColorAnimation(to)
        }
    }
}
