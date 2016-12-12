import UIKit

struct Showroom {
  
  static let screen = UIScreen.main.bounds.size
  static let screenCenter = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
  
  enum Control {
    case circleMenu
    case foldingCell
    case paperSwitch
    case paperOnboarding
    case expandingCollection
    case previewTransition
    case animationTabBar
    case realSearch
    case navigationStack
    case vr
  }
}
