import Foundation
import UIKit
import RAMAnimatedTabBarController
import Navigation_stack

extension Showroom.Control {
  
  var title: String {
    switch self {
    case .circleMenu: return "Circle Menu"
    case .foldingCell: return "Folding Cell"
    case .paperSwitch: return "Paper Switch"
    case .paperOnboarding: return "Pagination Controller"
    case .expandingCollection: return "Expanding Collection"
    case .previewTransition: return "Preview Transition"
    case .animationTabBar: return "Animation Tab Bar"
    case .reelSearch: return "Reel Search"
    case .navigationStack: return "Navigation Stack"
    case .vr: return "VR Demo"
    case .elongationPreview: return "Elongation Preview"
    case .glidingCollection: return "Gliding Collection"
    }
  }
  
  var info: String {
    switch self {
    case .circleMenu: return "A menu module with a circular layout. Works for applications with visually rich interactions."
    case .foldingCell: return "An expanding content cell inspired by folding paper material. It helps to navigate between cards in user interfaces."
    case .paperSwitch: return "The module paints over the parent view when the switch is turned on. Inspired by Google’s Material Design."
    case .paperOnboarding: return "A Material Design pagination controller. It is used for onboarding flows or tutorials."
    case .expandingCollection: return "A controller that expands cards from a preview to a middle state, and full screen. Can be used for navigation in card-based UIs."
    case .previewTransition: return "A simple preview gallery controller with a slight parallax effect. Works well for apps with visual content."
    case .animationTabBar: return "A module for adding animation to tab bar items. Helps to push native tab bar a bit further with subtle animations."
    case .reelSearch: return "The control helps to search faster by proactively providing the most relevant keywords as you type."
    case .navigationStack: return "A stack-modeled navigation controller. It helps to go through a deep structure of screens faster."
    case .vr: return "Universal web VR control created for mobiles. Makes navigation between product sections faster and more natural."
    case .elongationPreview: return "ElongationPreview is an elegant push-pop style view controller"
    case .glidingCollection: return "Gliding Collection is a smooth, flowing, customizable decision for a UICollectionView Swift Controller"
    }
  }
  
  var hours: String {
    switch self {
    case .circleMenu: return "120"
    case .foldingCell: return "160"
    case .paperSwitch: return "80"
    case .paperOnboarding: return "120"
    case .expandingCollection: return "160"
    case .previewTransition: return "120"
    case .animationTabBar: return "120"
    case .reelSearch: return "120"
    case .navigationStack: return "120"
    case .vr: return "160"
    case .elongationPreview: return "120"
    case .glidingCollection: return "120"
    }
  }
  
  var sharedURL: String {
    switch self {
    case .circleMenu: return "https://github.com/Ramotion/circle-menu"
    case .foldingCell: return "https://github.com/Ramotion/folding-cell"
    case .paperSwitch: return "https://github.com/Ramotion/paper-switch"
    case .paperOnboarding: return "https://github.com/Ramotion/paper-onboarding"
    case .expandingCollection: return "https://github.com/Ramotion/expanding-collection"
    case .previewTransition: return "https://github.com/Ramotion/preview-transition"
    case .animationTabBar: return "https://github.com/Ramotion/animated-tab-bar"
    case .reelSearch: return "https://github.com/Ramotion/reel-search"
    case .navigationStack: return "https://github.com/Ramotion/navigation-stack"
    case .vr: return "https://ramotion.github.io/vr-menu-demo/main.html"
    case .elongationPreview: return "https://github.com/Ramotion/elongation-preview"
    case .glidingCollection: return "https://github.com/ramotion/gliding-collection"
    }
  }
  
  var languages: String {
    switch self {
    case .circleMenu: return "Swift, UIKit"
    case .foldingCell: return "Swift, UIKit"
    case .paperSwitch: return "Swift, UIKit"
    case .paperOnboarding: return "Swift, UIKit"
    case .expandingCollection: return "Swift, UIKit"
    case .previewTransition: return "Swift, UIKit"
    case .animationTabBar: return "Swift, UIKit"
    case .reelSearch: return "Swift, UIKit"
    case .navigationStack: return "Swift, UIKit"
    case .vr: return "JavaScript, WebGL, WebVR"
    case .elongationPreview: return "Swift, UIKit"
    case .glidingCollection: return "Swift, UIKit"
    }
  }
    
    var image: String {
        switch self {
        case .circleMenu: return "CircleMenu"
        case .foldingCell: return "FoldingCell"
        case .paperSwitch: return "PaperSwitch"
        case .paperOnboarding: return "PaginationController"
        case .expandingCollection: return "ExpandingController"
        case .previewTransition: return "PreviewTransition"
        case .animationTabBar: return "AnimatedTabBar"
        case .reelSearch: return "ReelSearch"
        case .navigationStack: return "NavigationStack"
        case .vr: return "VRMenu"
        case .elongationPreview: return "ElongationPreview"
        case .glidingCollection: return "GlidingCollection"
        }
    }
  
  var viewController: UIViewController {
    let main = UIStoryboard(storyboard: .Main)
    let tabbar = UIStoryboard(storyboard: .AnimatedTabBar)
    let stack = UIStoryboard(storyboard: .NavigationStack)
    switch self {
    case .circleMenu: return UINavigationController(rootViewController: main.instantiateViewController() as CircleViewController)
    case .foldingCell: return UIViewController() // don't use look in carousevc
    case .paperSwitch: return UINavigationController(rootViewController: main.instantiateViewController() as SwitchViewController)
    case .paperOnboarding: return UINavigationController(rootViewController: main.instantiateViewController() as OnboardingViewController)
    case .expandingCollection: return UINavigationController(rootViewController: main.instantiateViewController() as DemoExpandingViewController)
    case .previewTransition: return UINavigationController(rootViewController: main.instantiateViewController() as DemoTableViewController)
    case .animationTabBar: return UINavigationController(rootViewController: tabbar.instantiateViewController() as RAMAnimatedTabBarController)
    case .reelSearch:
      
      return SearchViewController(viewModel: .shared) // don't use look in carousevc
    case .navigationStack: return stack.instantiateViewController() as NavigationStack
    case .vr: return main.instantiateViewController() as VRViewController
    case .elongationPreview: return ElongationDemoViewController(style: UITableViewStyle.plain)
    case .glidingCollection: return GlidingCollectionDemoViewController(nibName: nil, bundle: nil)
    }
  }
}
