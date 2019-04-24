import UIKit
import Nuke
import Firebase

private let kContentViewCornerRadius: CGFloat = 5

final class DribbbleShotCell: UICollectionViewCell {
    
    @IBOutlet weak private var shadowImageView: UIImageView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var imageView: DribbbleShotImageView!
    @IBOutlet weak private var loadingView: UIView!
    @IBOutlet weak private var gifImageView: UIImageView!
    
    private var isLoading = false
    private var loadingAnimationCompletion: (() -> ())?
    private var shouldCompleteAnimation = false
    
    var isEnabled = true {
        didSet {
            isEnabled ? setCellEnabled() : setCellDisabled()
        }
    }
    
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
                Nuke.cancelRequest(for: imageView)
                loadingView.alpha = 0
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
        containerView.backgroundColor = UIColor(white: 1, alpha: 0.1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        Nuke.cancelRequest(for: imageView)
        isEnabled = true
    }
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        checkIfSent()

        // image url
        if let imageUrl = state.imageUrl {
            startImageLoadingAnimation()
            let contentModes = ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
            let options = ImageLoadingOptions(contentModes: contentModes)
            Nuke.loadImage(with: imageUrl, options: options, into: imageView, progress: nil, completion: { [weak self] _, _ in
                self?.stopImageLoadingAnimation(completion: nil)
//                self?.checkIfSent()
            })
        } else {
            Nuke.cancelRequest(for: imageView)
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
    
    private func startImageLoadingAnimation() {
        guard !isLoading else { return }
        isLoading = true
        
        animateLoadingView()
    }
    
    private func animateLoadingView() {
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
    
    private func stopImageLoadingAnimation(completion: (() -> ())?) {
        loadingAnimationCompletion = completion
        shouldCompleteAnimation = true
    }
    
    private func checkIfSent() {
        
        switch state {
        case .default: break
        case .sent(let shot):
            let db = Firestore.firestore()
            let docRef = db.collection("shots").whereField("id", isEqualTo: shot.id)
            docRef.getDocuments { [weak self] (document, error) in
                guard error == nil else {
                    print("Document Error: ", error ?? "")
                    return
                }
                if document?.count != 0 {
                    self?.isEnabled = false
                }
            }
        case .wireframe: break
        }
    }
    
    private func setCellEnabled() {
        self.isUserInteractionEnabled = true
        gifImageView.alpha = 1
        imageView.alpha = 1
    }
    
    private func setCellDisabled() {
        self.isUserInteractionEnabled = false
        gifImageView.alpha = 0.3
        imageView.alpha = 0.3
    }
}
