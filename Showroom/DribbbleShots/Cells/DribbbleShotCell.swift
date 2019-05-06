import UIKit
import Nuke
import Firebase
import EasyPeasy
import RxSwift
import RxCocoa

private let kContentViewCornerRadius: CGFloat = 5

final class DribbbleShotCell: UICollectionViewCell {
    
    private let shotImageView = UIImageView()
    private let gifImageView = UIImageView()
    private let loadingView = UIView()
    private let wrapView = UIView()
    
    private var isLoading = false
    private var loadingAnimationCompletion: (() -> ())?
    private var shouldCompleteAnimation = false
    
    var shotState = BehaviorRelay<DribbbleShotState>(value: .wireframe)
    
    var isEnabled = true {
        didSet {
            isEnabled ? setCellEnabled() : setCellDisabled()
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.368627451, blue: 0.5529411765, alpha: 1)
        dropShadow(color: .black, radius: 5, side: 2, opasity: 0.8)
        contentView.setRoundedMask(radius: 5, size: CGSize(width: contentView.bounds.width, height: contentView.bounds.height))
        
        setSubviews()
        
        shotState
            .asObservable()
            .subscribe (
                onNext: {[weak self] shotState in
                    switch shotState {
                    case .default:
                        self?.prepareForLoadingImage()
                    case .sent:
                        self?.prepareForLoadingImage()
                    case .wireframe:
                        Nuke.cancelRequest(for: self!.shotImageView)
                    }
                }
            ).disposed(by: rx.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shotImageView.image = nil
        Nuke.cancelRequest(for: shotImageView)
        isEnabled = true
    }
    
    // MARK: Helpers
    private func prepareForLoadingImage() {
        if let imageUrl = shotState.value.imageUrl {
            startImageLoadingAnimation()
            
            let contentModes = ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFill, placeholder: .scaleAspectFill)
            let options = ImageLoadingOptions(contentModes: contentModes)
            Nuke.loadImage(with: imageUrl, options: options, into: shotImageView, progress: nil, completion: { [weak self] _, _ in
                self?.checkIfSent()
                self?.stopImageLoadingAnimation(completion: nil)
            })
        } else {
            Nuke.cancelRequest(for: shotImageView)
        }
    }
    
    private func setSubviews() {
        contentView.addSubview(shotImageView)
        shotImageView.easy.layout(
            Top().to(contentView),
            Left().to(contentView),
            Right().to(contentView),
            Bottom().to(contentView)
        )
        shotImageView.alpha = 0
        
        contentView.addSubview(gifImageView)
        gifImageView.easy.layout(
            Width(28),
            Height(15),
            Top(13).to(contentView),
            Right(13).to(contentView)
        )
        gifImageView.image = #imageLiteral(resourceName: "ico_gif")
        gifImageView.alpha = 0
        
        contentView.addSubview(loadingView)
        loadingView.easy.layout(
            Top().to(contentView),
            Left().to(contentView),
            Right().to(contentView),
            Bottom().to(contentView)
        )
        loadingView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        loadingView.alpha = 0
        
        wrapView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3998822774)
        contentView.addSubview(wrapView)
        wrapView.easy.layout(
            Top().to(contentView),
            Left().to(contentView),
            Right().to(contentView),
            Bottom().to(contentView)
        )
        wrapView.isHidden = true
    }
    
    private func updateWithShot(_ shot: Shot?) {
        let isAnimated = shot?.animated ?? false
        gifImageView.isHidden = !isAnimated
    }
    
    // MARK: Actions
    private func startImageLoadingAnimation() {
        guard !isLoading else { return }
        isLoading = true
        animateLoadingView()
    }
    
    private func animateLoadingView() {
        shotImageView.alpha = 0
        gifImageView.alpha = 0
        loadingView.alpha = 1

        let initialFrame = contentView.bounds.offsetBy(dx: -contentView.bounds.width, dy: 0)
        loadingView.frame = initialFrame

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.loadingView.frame = initialFrame.offsetBy(dx: initialFrame.width, dy: 0)
        }, completion: { [weak self] finished in
            let shouldCompleteAnimation = self?.shouldCompleteAnimation ?? false

            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self?.loadingView.frame = initialFrame.offsetBy(dx: initialFrame.width * 2, dy: 0)
                self?.shotImageView.alpha = 1
                self?.gifImageView.alpha = 1
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
        switch shotState.value {
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
        isUserInteractionEnabled = true
        wrapView.isHidden = true
    }
    
    private func setCellDisabled() {
        isUserInteractionEnabled = false
        wrapView.isHidden = false
    }
    
    private func dropShadow(color: UIColor, radius: CGFloat, side: CGFloat, opasity: Float) {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: side, height: side)
        layer.shadowRadius = radius
        layer.shadowOpacity = opasity
    }
}

extension UIView {
    func setRoundedMask(radius: CGFloat, size: CGSize) {
        let maskImageView = UIImageView()
        maskImageView.image = DrawFigure.roundedRect(radius: radius, color: .black, fillColor: .black, strokeWidth: 1)
            maskImageView.frame = CGRect(origin: .zero, size: size)
        self.mask = maskImageView
    }
}
