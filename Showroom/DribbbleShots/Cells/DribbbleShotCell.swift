import UIKit

private let kImageViewCornerRadius: CGFloat = 5

final class DribbbleShotCell: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    var state: DribbbleShotState = .wireframe {
        didSet {
            switch state {
            case .default:
                setNeedsLayout()
                imageView.backgroundColor = nil
            case .sent:
                setNeedsLayout()
                imageView.backgroundColor = nil
            case .wireframe:
                imageView.cancelImageRequest()
                imageView.backgroundColor = UIColor(red: 210 / 255.0, green: 94 / 255.0, blue: 141 / 255.0, alpha: 1)
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
        imageView.cancelImageRequest()
    }
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        layoutImageViewShadow()

        if let imageUrl = state.imageUrl {
            imageView.setImage(url: imageUrl, targetSize: imageView.bounds.size, contentMode: .aspectFill, processor: ("round", {
                return RoundedCornersImageProcessor(radius: kImageViewCornerRadius).process($0)
            }))
        }
    }
    
    private func layoutImageViewShadow() {
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: kImageViewCornerRadius).cgPath
    }
    
}
