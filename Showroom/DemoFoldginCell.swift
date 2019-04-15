import UIKit
import FoldingCell

class DemoFoldginCell: FoldingCell {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var fixedView: UIView!
    @IBOutlet weak var requiestButton: UIButton!
    
    @IBOutlet weak var topBar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        backgroundColor = .clear
        topBar.layer.cornerRadius = 10
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.26, 0.2, 0.2] // timing animation for each view
        return durations[itemIndex]
    }
}

// MARK: Methods
extension DemoFoldginCell {
    
    func setCellCollor(color: UIColor) {
        topView.backgroundColor = color
        leftView.backgroundColor = color
        fixedView.backgroundColor = color
        requiestButton.backgroundColor = color
    }
}
