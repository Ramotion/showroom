//
//  ShotViewController.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 02/08/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

final class ShotViewController: UIViewController, ZoomTransitionViewProviding {

    enum Result {
        case cancelled
        case sent
    }
    
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var sendButton: UIButton!
    
    private let completion: ((Result) -> Void)?
    
    init(completion: ((Result) -> Void)?) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Zoom Transition
    
    func sourceViewForZoomTransition(with identifier: String) -> UIView? {
        return imageView
    }
    
    func destinationViewForZoomTransition(with identifier: String) -> UIView? {
        return imageView
    }
    
    @IBAction
    private func closeButtonTapped() {
        completion?(.cancelled)
    }
    
}
