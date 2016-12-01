import UIKit
import EasyPeasy

struct CarouselSplashAnimationBroker {
  
  let collectionView: UICollectionView
  let infoButton: UIButton
  let contactUsButton: UIButton
  let pageLabel: UILabel
  let titleContainer: CarouselTitleView
  let topRectangle: UIImageView
  let bottomRectangle: UIImageView
  let backgroudView: UIView
  
  // MARK: Inits
  init(collectionView: UICollectionView,
       infoButton: UIButton,
       contactUsButton: UIButton,
       pageLabel: UILabel,
       titleContainer: CarouselTitleView,
       topRectangle: UIImageView,
       bottomRectangle: UIImageView,
       backgroudView: UIView) {
    
    self.collectionView = collectionView
    self.infoButton = infoButton
    self.contactUsButton = contactUsButton
    self.pageLabel = pageLabel
    self.titleContainer = titleContainer
    self.topRectangle = topRectangle
    self.bottomRectangle = bottomRectangle
    self.backgroudView = backgroudView
    
    [collectionView, contactUsButton, pageLabel, topRectangle, bottomRectangle, infoButton].forEach { $0.alpha = 0 }
    backgroudView.backgroundColor = .white
    
    // rLogo Animation
    rLogoAnimation()
    ramotionLogoAnimation()
    infoButtonAnimation()
  }
}

// MARK: Actions
extension CarouselSplashAnimationBroker {
  
  func rLogoAnimation() {
    let rLogoStartPosition = titleContainer.rLogo.layer.position
    titleContainer.rLogo.animate(duration: 0.001, [.layerPositionXY(from: Showroom.screenCenter, to: Showroom.screenCenter)])
    
    titleContainer.rLogo.animationImages = (0...36).flatMap { UIImage(named: ($0 < 9) ? "logo0000\($0)" : "logo000\($0)") }
    titleContainer.rLogo.animationDuration = 1.2
    titleContainer.rLogo.animationRepeatCount = 1
    titleContainer.rLogo.startAnimating()
    
    titleContainer.rLogo.animate(duration: 0.8, delay: 1.3, [.layerPositionX(from: Showroom.screenCenter.x, to: rLogoStartPosition.x)], timing: .easyInEasyOut)
    titleContainer.rLogo.animate(duration: 0.7, delay: 2.2, [.layerPositionY(from: Showroom.screenCenter.y, to: rLogoStartPosition.y)], timing: .easyInEasyOut)
  }
  
  func ramotionLogoAnimation() {
    guard let ramotionImage = titleContainer.ramotionLabel.image else { return }

    let ramotionLabelStartPosition = titleContainer.ramotionLabel.layer.position

    
    let xHidePosition = Showroom.screen.width + ramotionImage.size.width / 2
    let hidePosition = CGPoint(x: xHidePosition, y: Showroom.screenCenter.y)
    titleContainer.ramotionLabel.animate(duration: 0.001, [.layerPositionXY(from: hidePosition, to: hidePosition)])
    titleContainer.ramotionLabel.animate(duration: 0.8, delay: 1.4, [.layerPositionX(from: xHidePosition, to: ramotionLabelStartPosition.x)], timing: .easyInEasyOut)
    titleContainer.ramotionLabel.animate(duration: 0.7, delay: 2.2, [.layerPositionY(from: Showroom.screenCenter.y, to: ramotionLabelStartPosition.y)], timing: .easyInEasyOut)
  }
  
  func infoButtonAnimation() {
    infoButton.animate(duration: 0, delay: 2.5, [.springScale(from: 0, to: 1, bounce: 23, spring: 5)])
    infoButton.animate(duration: 0.1, delay: 2.5, [.alpha(to: 1)])
  }
  
}
