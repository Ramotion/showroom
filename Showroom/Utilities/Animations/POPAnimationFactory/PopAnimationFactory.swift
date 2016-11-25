import pop
import UIKit

func createPopAlphaAnimation(_ from: CGFloat?, to: CGFloat) -> POPBasicAnimation {
    
    let animaiton = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
    animaiton?.fromValue = (from)
    animaiton?.toValue = (to)
    return animaiton!
}

func createPopColorAnimation(_ to: UIColor) -> POPBasicAnimation {
    
    let animaiton = POPBasicAnimation(propertyNamed: kPOPLayerBackgroundColor)
    animaiton?.toValue = (to.cgColor)
    return animaiton!
}

func createPopTitleColorAnimation(_ to: UIColor) -> POPBasicAnimation {
    
    let animaiton = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
    animaiton?.toValue = (to.cgColor)
    return animaiton!
}
