import Foundation
import UPCarouselFlowLayout
import Device

class CarouselFlowLayout: UPCarouselFlowLayout {
  
  static let cellSize: CGSize = Size.screen4Inch == Device.size() ? CGSize(width: 270, height: 352) : CGSize(width: 307, height: 400)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    itemSize = CarouselFlowLayout.cellSize
    scrollDirection = .horizontal
    
    sideItemScale = 0.86
    sideItemAlpha = 0.49
    spacingMode = .fixed(spacing: 17)
  }
}
