import Foundation
import UIKit
import RAMAnimatedTabBarController
import NavigationStack

extension RAMControls.Control {
  
  var name: String {
    switch self {
    case .circleMenu: return "Circle Menu"
    case .foldingCell: return "FoldingCell"
    case .paperSwitch: return "Paper Switch"
    case .paperOnboarding: return "Paper Onboading"
    case .expandingCollection: return "Expanding Collection"
    case .previewTransition: return "Preview Transition"
    case .animationTabBar: return "Animation TabBar"
    case .realSearch: return "Real Search"
    case .navigationStack: return "Navigation Stack"
    }
  }
  
  var viewController: UIViewController {
    let main = UIStoryboard(storyboard: .Main)
    let tabbar = UIStoryboard(storyboard: .AnimatedTabBar)
    let stack = UIStoryboard(storyboard: .NavigationStack)
    switch self {
    case .circleMenu: return main.instantiateViewController() as CircleViewController
    case .foldingCell: return main.instantiateViewController() as FoldingTableViewController
    case .paperSwitch: return main.instantiateViewController() as SwitchViewController
    case .paperOnboarding: return main.instantiateViewController() as OnboardingViewController
    case .expandingCollection: return main.instantiateViewController() as DemoExpandingViewController
    case .previewTransition: return main.instantiateViewController() as DemoTableViewController
    case .animationTabBar: return tabbar.instantiateViewController() as RAMAnimatedTabBarController
    case .realSearch: return main.instantiateViewController() as SearchViewController
    case .navigationStack: return stack.instantiateViewController() as NavigationStack
    }
  }
}
