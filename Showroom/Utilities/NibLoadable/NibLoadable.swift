//
//  NibLoadable.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 26/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {
    
    static var nib: UINib { get }
    
}

extension NibLoadable {
    
    static public var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    public static func loadFromNib(withOwner owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> Self? {
        return nib.instantiate(withOwner: owner, options: options).first as? Self
    }
    
}
