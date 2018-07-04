import UIKit
import Nuke

private let kImageViewCornerRadius: CGFloat = 5

final class DribbbleShotCell: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    var manager = Manager.shared
    
    var imageUrl: URL? {
        didSet {
            setNeedsLayout()
        }
    }
    
    var sended: Bool = false {
        didSet {
            imageView.alpha = sended ? 0.3 : 1
        }
    }
    
    var isWireframe: Bool = false {
        didSet {
            if isWireframe {
                imageView.backgroundColor = UIColor(red: 210 / 255.0, green: 94 / 255.0, blue: 141 / 255.0, alpha: 1)
            } else {
                imageView.backgroundColor = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
        
        imageView.layer.cornerRadius = kImageViewCornerRadius
        
        imageView.layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageView.layer.shadowRadius = 8
        imageView.layer.shadowOpacity = 0.1
        
        layoutImageViewShadow()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        layoutImageViewShadow()

        if let url = imageUrl {
            let request = Nuke.Request(url: url, targetSize: imageView.bounds.size, contentMode: .aspectFill).processed(key: "round") { RoundedCornersImageProcessor(radius: kImageViewCornerRadius).process($0) }
            manager.loadImage(with: request, into: imageView)
        }
    }
    
    private func layoutImageViewShadow() {
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: kImageViewCornerRadius).cgPath
    }
    
}
