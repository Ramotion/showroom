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
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Providing Layout Information
    
    override func prepare() {
        let collectionViewWidth = collectionView?.bounds.width ?? 0
        let proposedSectionInset: CGFloat = 21
        let width = max(round((collectionViewWidth - proposedSectionInset * 2) / 2), 0)
        itemSize = CGSize(width: width, height: width)
        let sectionInsetLeft = floor((collectionViewWidth - itemSize.width * 2) / 2)
        let sectionInsetRight = collectionViewWidth - itemSize.width * 2 - sectionInsetLeft
        sectionInset = UIEdgeInsets(top: proposedSectionInset, left: sectionInsetLeft, bottom: proposedSectionInset, right: sectionInsetRight)
        
        super.prepare()
    }
    
}
