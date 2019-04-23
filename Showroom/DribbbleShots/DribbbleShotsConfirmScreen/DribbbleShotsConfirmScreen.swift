import UIKit
import RxSwift
import EasyPeasy
import Nuke

final class DribbbleShotsConfirmVC: UIViewController {
    var closeAction: (() -> Void)?
    var imageUrl: URL?
    var shotTitle = ""
    private let closeButton = UIButton()
    private let shotImageView = UIImageView()
    private let titleTextView = UITextView()
    private let messageTextView = UITextView()
    private let sendButton = UIButton()
    
    private let safeAreaTopInset = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    
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
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onViewTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Helpers
    func create() -> Observable<String> {
        return  Observable.create { [weak self] (observer) -> Disposable in
            self?.closeButton.addTarget(for: .touchUpInside, actionClosure: { [weak self] in
                observer.onCompleted()
                self?.dismiss(animated: true, completion: nil)
            })
            self?.sendButton.addTarget(for: .touchUpInside, actionClosure: { [weak self] in
                observer.onNext(self?.messageTextView.text ?? "")
                observer.onCompleted()
//                self?.closeAction?()
                self?.dismiss(animated: true, completion: nil)
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
}
