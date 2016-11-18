import UIKit

extension UICollectionView {
    
  func getReusableCellWithIdentifier<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: CollectionViewCellIdentifiable {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(T.cellIdentifier) ")
    }
    
    return cell
  }
}


protocol CollectionViewCellIdentifiable {
  static var cellIdentifier: String { get }
}

extension CollectionViewCellIdentifiable where Self: UICollectionViewCell {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionViewCell : CollectionViewCellIdentifiable { }
