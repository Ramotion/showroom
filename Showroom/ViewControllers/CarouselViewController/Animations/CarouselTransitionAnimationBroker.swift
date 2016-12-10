import UIKit

class CarouselTransitionAnimationBroker {
  
  let collectionView: UICollectionView
  let infoButton: UIButton
  let contactUsButton: UIButton
  let pageLabel: UILabel
  let titleContainer: CarouselTitleView
  let bottomContainer: UIView
  
  fileprivate var contactUsButtonPositionY: CGFloat = 0
  
  init(collectionView: UICollectionView,
       infoButton: UIButton,
       contactUsButton: UIButton,
       pageLabel: UILabel,
       titleContainer: CarouselTitleView,
       bottomContainer: UIView) {
    self.collectionView = collectionView
    self.infoButton = infoButton
    self.contactUsButton = contactUsButton
    self.pageLabel = pageLabel
    self.titleContainer = titleContainer
    self.bottomContainer = bottomContainer
  }
}

// MARK: Methods
extension CarouselTransitionAnimationBroker {
  
  func showTranstion(collectionItemIndex: Int) {
    contactUsButtonAnimation(hidden: true)
    infoButtonAnimation(hidden: true)
    pageLabelAnimation(hidden: true)
    titleAnimation(hidden: true)
    collectionViewAnimation(hidden: true, index: collectionItemIndex)
  }
  
  func hideTranstion(collectionItemIndex: Int) {
    contactUsButtonAnimation(hidden: false)
    infoButtonAnimation(hidden: false)
    pageLabelAnimation(hidden: false)
    titleAnimation(hidden: false)
    collectionViewAnimation(hidden: false, index: collectionItemIndex)
  }
}

// MARK: Animations
private extension CarouselTransitionAnimationBroker {
  
  func contactUsButtonAnimation(hidden: Bool) {
    
    let startPosition: CGFloat
    let hidePosition: CGFloat
    if hidden {
      contactUsButtonPositionY = contactUsButton.layer.position.y
      startPosition = contactUsButtonPositionY
      hidePosition = bottomContainer.bounds.size.height + contactUsButton.bounds.height / 2
    } else {
      hidePosition = contactUsButtonPositionY
      startPosition = bottomContainer.bounds.size.height + contactUsButton.bounds.height / 2
    }
    
    contactUsButton.animate(duration: 0.3, [
      .layerPositionY(from: startPosition , to: hidePosition),
      ],
      timing: .easyIn)
  }
  
  func infoButtonAnimation(hidden: Bool) {
    let from, to: CGFloat
    if hidden == true {
      from = 1
      to = 0
    } else {
      from = 0
      to = 1
    }
    infoButton.animate(duration: 0.3, [.viewScale(from: from, to: to)], timing: .easyInEasyOut)
  }
  
  func pageLabelAnimation(hidden: Bool) {
    let alpha: CGFloat = hidden == true ? 0 : 1
    pageLabel.animate(duration: 0.3, [.alpha(to: alpha)], timing: .easyInEasyOut)
  }
  
  func titleAnimation(hidden: Bool) {
    let to, from: CGFloat
    if hidden == true {
      to = -titleContainer.rLogo.bounds.height / 2
      from = titleContainer.rLogo.center.y
    } else {
      from = -titleContainer.rLogo.bounds.height / 2
      to = titleContainer.center.y
    }
    
    titleContainer.rLogo.animate(duration: 0.3, [.layerPositionY(from: from, to: to)], timing: .easyInEasyOut)
    titleContainer.ramotionLabel.animate(duration: 0.3, [.layerPositionY(from: from, to: to)], timing: .easyInEasyOut)
  }
  
  func collectionViewAnimation(hidden: Bool, index: Int) {
    guard let item = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) else { return }
    let from, to: CGFloat
    if hidden == true {
      from = 1
      to = 2
    } else {
      from = 2
      to = 1
    }
    item.animate(duration: 0.5, [.viewScale(from: from, to: to)], timing: .easyInEasyOut) 
  }
}
