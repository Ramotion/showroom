import UIKit

private let kContentViewCornerRadius: CGFloat = 5

final class DribbbleShotCell: UICollectionViewCell {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var shadowImageView: UIImageView!
    @IBOutlet weak private var imageView: DribbbleShotImageView!
    @IBOutlet weak private var gifImageView: UIImageView!

    var state: DribbbleShotState = .wireframe {
        didSet {
            switch state {
            case .default(let shot):
                setNeedsLayout()
                containerView.backgroundColor = nil
                imageView.isTransparentOverlayVisible = false
                updateWithShot(shot)
            case .sent(let shot):
                setNeedsLayout()
                containerView.backgroundColor = nil
                imageView.isTransparentOverlayVisible = true
                updateWithShot(shot)
            case .wireframe:
                imageView.cancelImageRequest()
                containerView.backgroundColor = UIColor(red: 210 / 255.0, green: 94 / 255.0, blue: 141 / 255.0, alpha: 1)
                imageView.isTransparentOverlayVisible = false
                updateWithShot(nil)
            }
        }
    }
    
    private func updateWithShot(_ shot: Shot?) {
        let isAnimated = shot?.animated ?? false
        gifImageView.isHidden = !isAnimated
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
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

        // image url
        if let imageUrl = state.imageUrl {
            imageView.setImage(url: imageUrl, targetSize: imageView.bounds.size, contentMode: .aspectFill)
        } else {
            imageView.cancelImageRequest()
        }
        
        // mask
        do {
            let maskView: UIImageView
            if let mask = containerView.mask as? UIImageView {
                maskView = mask
            } else {
                maskView = UIImageView()
                containerView.mask = maskView
            }
            maskView.frame = containerView.bounds
            let maskViewImageSize = maskView.image?.size ?? .zero
            if maskViewImageSize != maskView.bounds.size {
                let image = UIImage.image(size: containerView.bounds.size) { context in
                    UIBezierPath(roundedRect: containerView.bounds, cornerRadius: kContentViewCornerRadius).fill()
                }
                maskView.image = image
            }
        }

        // shadow
        do {
            let image = UIImage.image(size: shadowImageView.bounds.size) { context in
                context.cgContext.setShadow(offset: CGSize(width: 0, height: 3), blur: 25, color: UIColor(white: 0, alpha: 0.12).cgColor)
                UIBezierPath(roundedRect: containerView.frame, cornerRadius: kContentViewCornerRadius).fill()
            }
            shadowImageView.image = image
        }
    }
    
}
