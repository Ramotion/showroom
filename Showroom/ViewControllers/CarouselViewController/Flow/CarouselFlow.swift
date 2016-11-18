import Foundation
import UPCarouselFlowLayout

fileprivate struct C {
  
  static let size = CGSize(width: 307, height: 400)
}

class CarouselFlowLayout: UPCarouselFlowLayout {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    itemSize = C.size
    scrollDirection = .horizontal
    
    sideItemScale = 0.86
    sideItemAlpha = 0.49
    spacingMode = .fixed(spacing: 17)
  }
}
