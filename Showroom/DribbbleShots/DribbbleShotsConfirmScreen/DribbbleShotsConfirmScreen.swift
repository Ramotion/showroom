import UIKit
import RxSwift
import EasyPeasy
import Nuke

final class DribbbleShotsConfirmVC: UIViewController {
    var imageUrl: URL?
    var shotTitle = ""
    private let closeButton = UIButton()
    private let shotImageView = UIImageView()
    private let titleTextView = UITextView()
    private let messageTextView = UITextView()
    private let sendButton = UIButton()
    private let ringAnimation = CABasicAnimation(keyPath: "transform.rotation")
    
    private let safeAreaTopInset = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        
        if let url = imageUrl {
            let options = ImageLoadingOptions(
                placeholder: #imageLiteral(resourceName: "dribbleIconBig"),
                transition: .fadeIn(duration: 0.5)
            )
            Nuke.loadImage(with: url, options: options, into: shotImageView)
        } else {
            shotImageView.image = #imageLiteral(resourceName: "dribbleIconBig")
        }
        
        view.addSubview(sendButton)
        sendButton.easy.layout(
            Height(.sendButtonHeight),
            Left(.subviewsSidePadding).to(view),
            Right(.subviewsSidePadding).to(view),
            Bottom(.sendButtonBottomPadding).to(view)
        )
        sendButton.setBackgroundImage(DrawFigure.roundedRect(radius: 5, color: .blueColor, fillColor: .blueColor), for: .normal)
        sendButton.titleLabel?.font = .graphik(style: .graphikMedium, size: 17)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.setTitle("SEND", for: .normal)
        
        view.addSubview(messageTextView)
        messageTextView.easy.layout(
            Left(.subviewsSidePadding).to(view),
            Right(.subviewsSidePadding).to(view),
            Bottom(.messageTextViewBottomPadding).to(sendButton)
        )
        messageTextView.textAlignment = .left
        messageTextView.font = .graphik(style: .graphikRegular, size: 14)
        messageTextView.backgroundColor = .clear
        messageTextView.layer.borderWidth = 0.5
        messageTextView.layer.borderColor = UIColor.lightGrey.cgColor
        messageTextView.layer.cornerRadius = 7
        
        view.addSubview(shotImageView)
        shotImageView.easy.layout(
            Height(.shotImageViewHeight).with(.high),
            Top(safeAreaTopInset).to(view),
            Left().to(view),
            Right().to(view)
        )
        shotImageView.backgroundColor = .clear
        
        view.addSubview(titleTextView)
        titleTextView.easy.layout(
            Top(.titleTextViewTopPadding).to(shotImageView),
            Left(.subviewsSidePadding).to(view),
            Right(.subviewsSidePadding).to(view),
            Bottom(.titleTextViewBottomPadding).to(messageTextView)
        )
        titleTextView.text = shotTitle.withoutHtmlTags
        titleTextView.textAlignment = .left
        titleTextView.font = .graphik(style: .graphikRegular, size: 20)
        titleTextView.sizeToFit()
        titleTextView.isEditable = false
        titleTextView.isScrollEnabled = false
        
        view.addSubview(closeButton)
        closeButton.easy.layout(
            Size(.closeButtonSide),
            Right(.closeButtonSidePadding).to(view),
            Top(.closeButtonSidePadding + safeAreaTopInset).to(view)
        )
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.addTarget(for: .touchUpInside, actionClosure: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onViewTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sendButton.imageView?.layer.removeAllAnimations()
    }
    
    // MARK: Helpers
    func create() -> Observable<String> {
        return  Observable.create { [weak self] (observer) -> Disposable in
            self?.sendButton.addTarget(for: .touchUpInside, actionClosure: { [weak self] in
                self?.animateRing()
                observer.onNext(self?.messageTextView.text ?? "")
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    // MARK: Actions
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            moveContentUp(offset: keyboardFrame.size.height)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) { moveContentDown() }
    
    @objc private func onViewTap(sender: UITapGestureRecognizer? = nil) { messageTextView.resignFirstResponder() }
    
    private func moveContentUp(offset: CGFloat) {
        sendButton.easy.layout(Bottom(offset + .sendButtonBottomPadding).to(view))
        closeButton.easy.layout(Top(-30).to(view))
        
        let shotImageOffset: CGFloat = view.safeAreaInsets.top + .shotImageViewHeight + .titleTextViewTopPadding + titleTextView.frame.size.height
        shotImageView.easy.layout(Top(-shotImageOffset).to(view))
        
        titleTextView.easy.layout(Bottom(.titleTextViewBottomPadding + view.safeAreaInsets.top * 2).to(messageTextView))
        
        UIView.animate(withDuration: 0.3) { [weak self] in self?.view.layoutIfNeeded() }
    }
    
    private func moveContentDown() {
        sendButton.easy.layout(Bottom(.sendButtonBottomPadding).to(view))
        closeButton.easy.layout(Top(.closeButtonSidePadding + view.safeAreaInsets.top).to(view))
        shotImageView.easy.layout(Top(view.safeAreaInsets.top).to(view))
        titleTextView.easy.layout(Bottom(.titleTextViewBottomPadding).to(messageTextView))
        UIView.animate(withDuration: 0.3) { [weak self] in self?.view.layoutIfNeeded() }
    }
    
    private func animateRing() {
        sendButton.setTitle(nil, for: .normal)
        let ringImage = DrawFigure.openRing(radius: 19, color: .white, lineWidth: 3)
        sendButton.setImage(ringImage, for: .normal)
        
        ringAnimation.fromValue = 0
        ringAnimation.toValue = 2 * CGFloat.pi
        ringAnimation.duration = 1
        ringAnimation.fillMode = CAMediaTimingFillMode.forwards
        ringAnimation.repeatCount = .infinity
        sendButton.imageView?.layer.add(ringAnimation, forKey: nil)
    }
}
