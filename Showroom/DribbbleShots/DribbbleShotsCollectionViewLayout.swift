//
//  DribbbleShotsCollectionViewLayout.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 29/06/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

final class DribbbleShotsCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        sectionInset = UIEdgeInsets(top: 34, left: 34, bottom: 34, right: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Providing Layout Information
    
    override func prepare() {
        let collectionViewWidth = collectionView?.bounds.width ?? 0
        let width = max(floor((collectionViewWidth - sectionInset.left - sectionInset.right) / 2 - 12), 0)
        itemSize = CGSize(width: width, height: width)
        minimumInteritemSpacing = collectionViewWidth - sectionInset.left - sectionInset.right - width * 2
        minimumLineSpacing = minimumInteritemSpacing
        
        super.prepare()
    }
    
}
