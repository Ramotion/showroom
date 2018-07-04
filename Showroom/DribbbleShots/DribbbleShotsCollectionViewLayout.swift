//
//  DribbbleShotsCollectionViewLayout.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 29/06/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

final class DribbbleShotsCollectionViewLayout: UICollectionViewFlowLayout {
    
    private enum AnimationState {
        case prepared
        case animating
        case finished
    }
    
    private var animator: UIDynamicAnimator!
    
    override init() {
        super.init()
        
        animator = UIDynamicAnimator(collectionViewLayout: self)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var animationState = AnimationState.prepared
    
    // MARK: - Providing Layout Attributes
    
    override func prepare() {
        // calculate item size and insets
        let collectionViewWidth = collectionView?.bounds.width ?? 0
        let proposedSectionInset: CGFloat = 21
        let width = max(round((collectionViewWidth - proposedSectionInset * 2) / 2), 0)
        itemSize = CGSize(width: width, height: width)
        let sectionInsetLeft = floor((collectionViewWidth - itemSize.width * 2) / 2)
        let sectionInsetRight = collectionViewWidth - itemSize.width * 2 - sectionInsetLeft
        sectionInset = UIEdgeInsets(top: proposedSectionInset, left: sectionInsetLeft, bottom: proposedSectionInset, right: sectionInsetRight)
        
        super.prepare()
        
        switch animationState {
        case .prepared:
            ()
        case .animating:
            if animator.behaviors.count == 0 {
                let rectSize = collectionView.flatMap { CGSize(width: max($0.contentSize.width, $0.bounds.width), height: max($0.contentSize.height, $0.bounds.height)) } ?? .zero
                let layoutAttributes = super.layoutAttributesForElements(in: CGRect(origin: .zero, size: rectSize)) ?? []

                // add behaviors to layout attributes
                // chain items one to another vertically
                for layoutAttribute in layoutAttributes {
                    let behaviour = UIAttachmentBehavior(item: layoutAttribute, attachedToAnchor: layoutAttribute.center)
                    behaviour.length = 0
                    behaviour.damping = 0.8
                    behaviour.frequency = 1
                    animator.addBehavior(behaviour)
                }
                
                // move items to initial position
                for layoutAttribute in layoutAttributes {
                    animator.updateItem(usingCurrentState: layoutAttributesByTransformingLayoutAttributesForPreparedAnimationState(layoutAttribute))
                }
            }
        case .finished:
            ()
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        switch animationState {
        case .prepared:
            return super.layoutAttributesForElements(in: rect)?.map { layoutAttributesByTransformingLayoutAttributesForPreparedAnimationState($0) }
        case .animating:
            return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
        case .finished:
            return super.layoutAttributesForElements(in: rect)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch animationState {
        case .prepared:
            return super.layoutAttributesForItem(at: indexPath).flatMap { layoutAttributesByTransformingLayoutAttributesForPreparedAnimationState($0) }
        case .animating:
            return animator.layoutAttributesForCell(at: indexPath)
        case .finished:
            return super.layoutAttributesForItem(at: indexPath)
        }
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
        guard animationState == .prepared else { return }
        
        animationState = .animating
        invalidateLayout()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1.3)) {
            self.animationState = .finished
            self.invalidateLayout()
            completion?()
        }
    }
    
}
