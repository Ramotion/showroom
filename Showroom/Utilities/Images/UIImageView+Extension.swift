//
//  UIImage+Extension.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 05/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit
import Nuke
import ObjectiveC.runtime

private var kUIImageManagerAssociatedObjectKey = 0
private var kUIImageRequestAssociatedObjectKey = 0

extension UIImageView {
    
    private var imageManager: Nuke.Manager? {
        get {
            return objc_getAssociatedObject(self, &kUIImageManagerAssociatedObjectKey) as? Manager
        }
        set {
            objc_setAssociatedObject(self, &kUIImageManagerAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func cancelImageRequest() {
        let manager = imageManager ?? Manager.shared
        manager.cancelRequest(for: self)
    }
    
    private func setImage(request: Nuke.Request, handler: Manager.Handler? = nil) {
        let manager = imageManager ?? Manager.shared
        if let handler = handler {
            manager.loadImage(with: request, into: self, handler: handler)
        } else {
            manager.loadImage(with: request, into: self)
        }
    }
    
    func setImage(url: URL, progress: ProgressHandler? = nil, processor: (String, ((UIImage) -> UIImage?))? = nil, handler: Manager.Handler? = nil) {
        var request = Nuke.Request(url: url)
        request.progress = progress
        if let processor = processor {
            request.process(key: processor.0, processor.1)
        }
        setImage(request: request, handler: handler)
    }
    
    func setImage(urlRequest: URLRequest, progress: ProgressHandler? = nil, processor: (String, ((UIImage) -> UIImage?))? = nil, handler: Manager.Handler? = nil) {
        var request = Nuke.Request(urlRequest: urlRequest)
        request.progress = progress
        if let processor = processor {
            request.process(key: processor.0, processor.1)
        }
        setImage(request: request, handler: handler)
    }
    
    func setImage(url: URL, targetSize: CGSize, contentMode: Decompressor.ContentMode, progress: ProgressHandler? = nil, processor: (String, ((UIImage) -> UIImage?))? = nil, handler: Manager.Handler? = nil) {
        var request = Nuke.Request(url: url, targetSize: targetSize, contentMode: contentMode)
        request.progress = progress
        if let processor = processor {
            request.process(key: processor.0, processor.1)
        }
        setImage(request: request, handler: handler)
    }
    
    func setImage(urlRequest: URLRequest, targetSize: CGSize, contentMode: Decompressor.ContentMode, progress: ProgressHandler? = nil, processor: (String, ((UIImage) -> UIImage?))? = nil , handler: Manager.Handler? = nil) {
        var request = Nuke.Request(urlRequest: urlRequest, targetSize: targetSize, contentMode: contentMode)
        request.progress = progress
        if let processor = processor {
            request.process(key: processor.0, processor.1)
        }
        setImage(request: request, handler: handler)
    }
    
}
