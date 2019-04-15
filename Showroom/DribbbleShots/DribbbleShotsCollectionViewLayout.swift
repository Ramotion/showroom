//
//  DribbbleShotsCollectionViewLayout.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 29/06/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

final class DribbbleShotsCollectionViewLayout: UICollectionViewFlowLayout {
    
    private struct Const {
        static let proposedSectionInset: CGFloat = 21
    }
    
    override init() {
        super.init()
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Providing Layout Attributes
    
    override func prepare() {
        let adjustedContentInsetTop: CGFloat = 89
        if #available(iOS 11.0, *) {
            let contentInsetTop = max(0, adjustedContentInsetTop - (collectionView?.safeAreaInsets.top ?? 0))
            let contentInsetBottom = max(0, Const.proposedSectionInset - (collectionView?.safeAreaInsets.bottom ?? 0))
            collectionView?.contentInset.top = contentInsetTop
            collectionView?.contentInset.bottom = contentInsetBottom
        } else {
            collectionView?.contentInset.top = adjustedContentInsetTop
            collectionView?.contentInset.bottom = Const.proposedSectionInset
        }
        
        // calculate item size and insets
        let collectionViewWidth = collectionView?.bounds.width ?? 0
        let width = max(round((collectionViewWidth - Const.proposedSectionInset * 2) / 2), 0)
        itemSize = CGSize(width: width, height: width)
        sectionInset.left = floor((collectionViewWidth - itemSize.width * 2) / 2)
        sectionInset.right = collectionViewWidth - itemSize.width * 2 - sectionInset.left
        
        super.prepare()
    }
    
    private func layoutAttributesByTransformingLayoutAttributesForPreparedAnimationState(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.center.y += 20
        let isInSecondColumn = layoutAttributes.indexPath.row % 2 == 1
        if isInSecondColumn {
            layoutAttributes.center.y += 10
        }
        return layoutAttributes
    }
    
    func animateItemsInPlace(completion: (() -> ())? = nil) {
        guard let collectionView = collectionView else { return }
        
        let cells = collectionView.visibleCells.sorted(by: {
            if $0.frame.minY == $1.frame.minY {
                return $0.frame.minX < $1.frame.minX
            }
            return $0.frame.minY < $1.frame.minY
        })
        
        let group = DispatchGroup()
        group.enter()
        
        for i in 0..<cells.count {
            let cell = cells[i]
            
            let cellOriginalFrame = cell.frame
            var cellInitialFrame = cellOriginalFrame.offsetBy(dx: 0, dy: 40)
            
            let isInSecondColumn = i % 2 == 1
            if isInSecondColumn {
                cellInitialFrame.origin.y += 10
            }
            
            cell.frame = cellInitialFrame
            
            group.enter()
            UIView.animate(withDuration: 0.5, delay: Double(i) * 0.05, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                cell.frame = cellOriginalFrame
            }, completion: { _ in
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
          completion?()
        }
        
        group.leave()
    }
    
}
