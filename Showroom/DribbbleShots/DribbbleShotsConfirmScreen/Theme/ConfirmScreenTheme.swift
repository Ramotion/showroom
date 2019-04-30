import UIKit

// MARK: Geometry
struct DrawFigure {
    static func roundedRect(radius: CGFloat, color: UIColor, fillColor: UIColor? = nil, strokeWidth: CGFloat = 1) -> UIImage {
        let imagesCache = NSCache<NSString, UIImage>()
        imagesCache.name = "Generated Images Cache"
        let key = "roundedBackground_\(radius)_\(color)_\(strokeWidth)" as NSString
        if let cached = imagesCache.object(forKey: key) { return cached }
        
        let size = CGSize(width: radius * 2, height: radius * 2)
        let image = UIGraphicsImageRenderer(size: size).image { context in
            let path = UIBezierPath(
                roundedRect: CGRect(origin: .zero, size: size),
                cornerRadius: radius
            )
            path.lineWidth = strokeWidth
            color.setStroke()
            if let fillColor = fillColor {
                fillColor.setFill()
                path.fill()
            }
            path.stroke()
        }
        
        let resizableImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius), resizingMode: .stretch)
        
        imagesCache.setObject(resizableImage, forKey: key)
        return resizableImage
    }
    
    static func openRing(radius: CGFloat, color: UIColor, lineWidth: CGFloat) -> UIImage {
        let imagesCache = NSCache<NSString, UIImage>()
        imagesCache.name = "Generated Images Cache"
        let key = "openRing_\(radius)_\(color)_\(lineWidth)" as NSString
        if let cached = imagesCache.object(forKey: key) { return cached }
        
        let size = CGSize(width: radius * 2, height: radius * 2)
        let image = UIGraphicsImageRenderer(size: size).image { context in
            
            let path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius),
                                          radius: radius - 1.5, startAngle: -0.2 * CGFloat.pi,
                                          endAngle: 1.1 * CGFloat.pi, clockwise: true)
            
            path.lineWidth = lineWidth
            color.setStroke()
            path.stroke()
        }
        
        let resizableImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius), resizingMode: .stretch)
        
        imagesCache.setObject(resizableImage, forKey: key)
        return resizableImage
    }
    
    
}

// MARK: Sizes
extension CGFloat {
    // Buttons
    static let closeButtonSide: CGFloat                 = 49
    static let sendButtonHeight: CGFloat                = 65
    // Text Views
    static let messageTextViewHeight: CGFloat           = 200
//    static let titleTextViewHeight: CGFloat             = 50
    // Image Views
    static let shotImageViewHeight: CGFloat             = 270
    // Paddings
    static let subviewsSidePadding: CGFloat             = 41
    static let sendButtonBottomPadding: CGFloat         = 24
    static let messageTextViewBottomPadding: CGFloat    = 20
    static let titleTextViewBottomPadding: CGFloat      = 10
    static let titleTextViewTopPadding: CGFloat         = 19
    static let closeButtonSidePadding: CGFloat          = 26
    static let closeButtonTopPadding: CGFloat           = 20
}

// MARK: Colors
extension UIColor {
    static let blueColor                                = #colorLiteral(red: 0.09411764706, green: 0.3882352941, blue: 0.862745098, alpha: 1) // #1863DC
    static let lightGrey                                = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1) // #E2E2E2
}

// MARK: Fonts
enum FontGraphik: String {
    case graphikRegular     = "Graphik-Regular"
    case graphikMedium      = "Graphik-Medium"
    case graphikSemibold    = "Graphik-Semibold"
}

extension UIFont {
    class func graphik(style: FontGraphik, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
