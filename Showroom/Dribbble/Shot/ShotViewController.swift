//
//  ShotViewController.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 02/08/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

final class ShotViewController: ScrollViewController, ZoomTransitionViewProviding {

    enum Result {
        case cancelled
        case sent
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var sendButton: UIButton!
    private let closeButton = UIButton(type: .system)
    private let shot: Shot
    private let completion: ((Result) -> Void)?
    
    init(shot: Shot, completion: ((Result) -> Void)?) {
        self.shot = shot
        self.completion = completion
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Managing the View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderWidth = 1 / UIScreen.main.scale
        textView.layer.borderColor = UIColor(white: 226 / 255.0, alpha: 1).cgColor
        textView.layer.cornerRadius = 10
        
        closeButton.setImage(#imageLiteral(resourceName: "dribbble_close"), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        sendButton.backgroundColor = UIColor(red: 24 / 255.0, green: 99 / 255.0, blue: 220 / 255.0, alpha: 1)
        sendButton.layer.shadowColor = UIColor(red: 142 / 255.0, green: 157 / 255.0, blue: 181 / 255.0, alpha: 0.76).cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        sendButton.layer.shadowRadius = 15
        sendButton.layer.cornerRadius = 10
        
        shot.imageUrl.flatMap {
            imageView.setImage(url: $0, targetSize: imageView.bounds.size, contentMode: .aspectFill)
        }
    }
    
    // MARK: - Configuring the View’s Layout Behavior
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        closeButton.center = CGPoint(x: view.bounds.width - closeButton.bounds.width, y: view.bounds.height - closeButton.bounds.height)
        sendButton.layer.shadowPath = UIBezierPath(roundedRect: sendButton.bounds, cornerRadius: sendButton.layer.cornerRadius).cgPath
    }
    
    // MARK: - Zoom Transition
    
    func sourceViewForZoomTransition(with identifier: String) -> UIView? {
        loadViewIfNeeded()
        return imageView
    }
    
    func destinationViewForZoomTransition(with identifier: String) -> UIView? {
        loadViewIfNeeded()
        return imageView
    }
    
    @objc
    private func closeButtonTapped() {
        completion?(.cancelled)
    }
    
}
