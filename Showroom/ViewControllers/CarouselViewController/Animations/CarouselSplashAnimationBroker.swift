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
  let bottomContainer: UIView
  
  // MARK: Inits
  init(collectionView: UICollectionView,
       infoButton: UIButton,
       contactUsButton: UIButton,
       pageLabel: UILabel,
       titleContainer: CarouselTitleView,
       topRectangle: UIImageView,
       bottomRectangle: UIImageView,
       backgroudView: UIView,
       bottomContainer: UIView) {
    
    self.collectionView = collectionView
    self.infoButton = infoButton
    self.contactUsButton = contactUsButton
    self.pageLabel = pageLabel
    self.titleContainer = titleContainer
    self.topRectangle = topRectangle
    self.bottomRectangle = bottomRectangle
    self.backgroudView = backgroudView
    self.bottomContainer = bottomContainer
    
    [collectionView, titleContainer.rLogo, titleContainer.ramotionLabel, contactUsButton, pageLabel, infoButton].forEach { $0.alpha = 0 }
  }
}

// MARK: Methods
extension CarouselSplashAnimationBroker {
  
  func startAnimations() {
    rLogoAnimation()
    ramotionLogoAnimation()
    infoButtonAnimation()
    
    backgroundAnimation()
    contactUsButtonAnimation()
    collectionViewAnimation()
  }
}

// MARK: Actions
private extension CarouselSplashAnimationBroker {
  
  func rLogoAnimation() {
    let rLogoStartPosition = titleContainer.rLogo.layer.position
    titleContainer.rLogo.animate(duration: 0.001, [.layerPositionXY(from: Showroom.screenCenter, to: Showroom.screenCenter), .alpha(to: 1)])
    
    titleContainer.rLogo.animationImages = (0...36).flatMap { UIImage(named: ($0 < 9) ? "logo0000\($0)" : "logo000\($0)") }
    titleContainer.rLogo.animationDuration = 1.2
    titleContainer.rLogo.animationRepeatCount = 1
    titleContainer.rLogo.startAnimating()
    
    titleContainer.rLogo.animate(duration: 0.8, delay: 1.3, [.layerPositionX(from: Showroom.screenCenter.x, to: rLogoStartPosition.x)], timing: .easyInEasyOut) {
      self.titleContainer.rLogo.layer.shouldRasterize = true
    }
    titleContainer.rLogo.animate(duration: 0.7, delay: 2.2, [.layerPositionY(from: Showroom.screenCenter.y, to: rLogoStartPosition.y)], timing: .easyInEasyOut){
      self.titleContainer.rLogo.layer.shouldRasterize = false
    }
  }
  
  func ramotionLogoAnimation() {
    guard let ramotionImage = titleContainer.ramotionLabel.image else { return }

    let ramotionLabelStartPosition = titleContainer.ramotionLabel.layer.position

    
    let xHidePosition = Showroom.screen.width + ramotionImage.size.width / 2
    let hidePosition = CGPoint(x: xHidePosition, y: Showroom.screenCenter.y)
    titleContainer.ramotionLabel.animate(duration: 0.001, [.layerPositionXY(from: hidePosition, to: hidePosition), .alpha(to: 1)])
    titleContainer.ramotionLabel.animate(duration: 0.8, delay: 1.4, [.layerPositionX(from: xHidePosition, to: ramotionLabelStartPosition.x)], timing: .easyInEasyOut)
    titleContainer.ramotionLabel.animate(duration: 0.7, delay: 2.23, [.layerPositionY(from: Showroom.screenCenter.y, to: ramotionLabelStartPosition.y)], timing: .easyInEasyOut)
  }
  
  func infoButtonAnimation() {
    infoButton.animate(duration: 0, delay: 2.5, [.springScale(from: 0, to: 1, bounce: 20, spring: 5)])
    infoButton.animate(duration: 0.1, delay: 2.5, [.alpha(to: 1)])
  }
  
  func backgroundAnimation() {
    backgroudView.backgroundColor = .white
    backgroudView.animate(duration: 0.8, delay: 0.5, [.color(to: UIColor(red:0.93, green:0.93, blue:0.95, alpha:1.00))])
  }
  
  func contactUsButtonAnimation() {
    let startPosition = contactUsButton.layer.position
    let hidePosition = bottomContainer.bounds.size.height + contactUsButton.bounds.height / 2
    contactUsButton.animate(duration: 0.001, [
      .layerPositionY(from: hidePosition , to: hidePosition),
      .alpha(to: 1)
      ])
    
    contactUsButton.animate(duration: 0.8,
                            delay: 2.2,
                            [.layerPositionY(from: hidePosition, to: startPosition.y)],
                            timing: .easyInEasyOut) 
  }
  
  func collectionViewAnimation() {
    let startPositionX = collectionView.layer.position.x
    let hidePosition = collectionView.bounds.size.width / 2 + Showroom.screen.width
    collectionView.animate(duration: 0.001, [.layerPositionX(from: hidePosition, to: hidePosition), .alpha(to: 1)])
    collectionView.layer.shouldRasterize = true
    
    collectionView.animate(duration: 0.5,
                            delay: 2.5,
                            [.layerPositionX(from: hidePosition, to: startPositionX)],
                            timing: .easyInEasyOut) { _ in
                              self.collectionView.layer.shouldRasterize = false
                            }
  }
}
