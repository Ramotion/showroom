import UIKit

private let kContentViewCornerRadius: CGFloat = 5

final class DribbbleShotCell: UICollectionViewCell {
    
    @IBOutlet weak private var shadowImageView: UIImageView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var imageView: DribbbleShotImageView!
    @IBOutlet weak private var loadingView: UIView!
    @IBOutlet weak private var gifImageView: UIImageView!

    var state: DribbbleShotState = .wireframe {
        didSet {
            switch state {
            case .default(let shot):
                setNeedsLayout()
                loadingView.alpha = 0
                updateWithShot(shot)
            case .sent(let shot):
                setNeedsLayout()
                loadingView.alpha = 0
                updateWithShot(shot)
            case .wireframe:
                imageView.cancelImageRequest()
                loadingView.alpha = 0
                updateWithShot(nil)
            }
            updateTransparentOverlayVisibility()
        }
    }
    
    private func updateTransparentOverlayVisibility() {
        guard !isLoading else {
            imageView.isTransparentOverlayVisible = true
            return
        }
        
        switch state {
        case .default, .wireframe:
            imageView.isTransparentOverlayVisible = false
        case .sent:
            imageView.isTransparentOverlayVisible = true
        }
    }
    
    private func updateWithShot(_ shot: Shot?) {
        let isAnimated = shot?.animated ?? false
        gifImageView.isHidden = !isAnimated
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
        containerView.backgroundColor = UIColor(white: 1, alpha: 0.1)
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
            startImageLoadingAnimation()
            imageView.setImage(url: imageUrl, targetSize: imageView.bounds.size, contentMode: .aspectFill, handler: { [weak self] result, fromCache in
                self?.imageView.image = result.value
                self?.stopImageLoadingAnimation(completion: nil)
            })
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
                UIColor(red: 254 / 255.0, green: 55 / 255.0, blue: 138 / 255.0, alpha: 1).setFill()
                context.cgContext.setShadow(offset: CGSize(width: 0, height: 3), blur: 25, color: UIColor(white: 0, alpha: 0.12).cgColor)
                UIBezierPath(roundedRect: containerView.frame, cornerRadius: kContentViewCornerRadius).fill()
            }
            shadowImageView.image = image
        }
    }
    
    private var isLoading = false
    
    private func startImageLoadingAnimation() {
        guard !isLoading else { return }
        isLoading = true
        
        animateLoadingView()
    }
    
    private func animateLoadingView() {
        updateTransparentOverlayVisibility()
        imageView.alpha = 0
        loadingView.alpha = 1

        let initialFrame = containerView.bounds.offsetBy(dx: -containerView.bounds.width, dy: 0)
        loadingView.frame = initialFrame
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.loadingView.frame = initialFrame.offsetBy(dx: initialFrame.width, dy: 0)
        }, completion: { [weak self] finished in
            let shouldCompleteAnimation = self?.shouldCompleteAnimation ?? false
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self?.loadingView.frame = initialFrame.offsetBy(dx: initialFrame.width * 2, dy: 0)
                self?.imageView.alpha = 1
                self?.loadingView.alpha = 0
                self?.updateTransparentOverlayVisibility()
            }, completion: { finished in
                if shouldCompleteAnimation {
                    self?.loadingAnimationCompletion?()
                    self?.loadingAnimationCompletion = nil
                } else {
                    self?.animateLoadingView()
                }
            })
        })
    }
    
    private var loadingAnimationCompletion: (() -> ())?
    private var shouldCompleteAnimation = false
    
    private func stopImageLoadingAnimation(completion: (() -> ())?) {
        loadingAnimationCompletion = completion
        shouldCompleteAnimation = true
    }
    
}
