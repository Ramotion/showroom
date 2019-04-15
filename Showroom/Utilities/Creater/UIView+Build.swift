import UIKit
import EasyPeasy

protocol BuildCompatibility: class {
  static func build(color: UIColor, alpha: CGFloat) -> View
}

extension BuildCompatibility where Self: UIView {
  
  static func build(color: UIColor = .white, alpha: CGFloat = 1) -> View {
    let view = Self.init(frame: .zero)
    view.backgroundColor = color
    return view
  }
}

extension UIView: BuildCompatibility {}
