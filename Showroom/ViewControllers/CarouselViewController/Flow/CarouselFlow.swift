import Foundation
import UPCarouselFlowLayout
import Device

class CarouselFlowLayout: UPCarouselFlowLayout {
  
  static var cellSize: CGSize {
    if  Size.screen4Inch == Device.size() { return CGSize(width: 270, height: 352) }
    if  Size.screen3_5Inch == Device.size() { return CGSize(width: 270, height: 352) }
    return CGSize(width: 307, height: 400)
  } 
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    itemSize = CarouselFlowLayout.cellSize
    scrollDirection = .horizontal
    
    sideItemScale = 0.86
    sideItemAlpha = 0.49
    spacingMode = .fixed(spacing: 17)
  }
}
