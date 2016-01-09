import UIKit

enum LEOMMenuButtonStates : Int {
    case inaccesible
    case current
    case done
    case accesibleEmpty
    case accesibleDone
}

protocol LEOMenuButtonProtocol {
    func clicked(sender: LEOMenuButton)
}

@IBDesignable class LEOMenuButton: BaseDesignable {
    let maxheightConstraint : CGFloat = 41
    let minheightConstraint : CGFloat = 35
    let stepFactor : CGFloat = 10
    let badgeMargin : CGFloat = 5
    
    var nibName: String = "LEOMenuButton"
    
    var delegate:LEOMenuButtonProtocol?
    
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var stateImages : [UIImage]!
    var state = LEOMMenuButtonStates.inaccesible
    
    var badge : Int? {
        didSet {
            badgeLabel.text = String(badge ?? 0)
            badgeLabel.sizeToFit()
            widthConstraint.constant = badgeLabel.frame.size.width +  2 * badgeMargin
            badgeLabel.hidden = !((badge ?? 0) > 0)
            badgeLabel.layoutIfNeeded()
        }
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame, nibName: nibName)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, nibName: nibName)
    }
    
    override func setupProperties() {
        badgeLabel.hidden = true
        badgeLabel.layer.masksToBounds = true
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.layer.borderColor = UIColor.orangeColor().CGColor
        badgeLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
        badgeLabel.layer.borderWidth = 1
        badgeLabel.textColor = UIColor.orangeColor()
        badgeLabel.numberOfLines = 1
        badgeLabel.font = UIFont.systemFontOfSize(10)
        badgeLabel.textAlignment = NSTextAlignment.Center
    }
    
    @IBAction func click(sender: AnyObject) {
        if self.state != LEOMMenuButtonStates.inaccesible && self.state != LEOMMenuButtonStates.current {
            self.touchAnimation()
        }
        
        if let letDelegate = delegate {
            letDelegate.clicked(self)
        }
    }
    
    func setState(state : LEOMMenuButtonStates, animated : Bool) {
        self.state = state
        animated ? toState(state) : (self.stateImageView.image = stateImages![state.rawValue])
    }
    
    func stretch(factor : CGFloat) {
        var newConstant = minheightConstraint - (factor/stepFactor)
        newConstant = min(maxheightConstraint, newConstant)
        newConstant = max(minheightConstraint, newConstant)
        self.heightConstraint.constant = newConstant
        self.view.layoutIfNeeded()
    }
    
    func toState(state : LEOMMenuButtonStates) {
        UIView.transitionWithView(self.stateImageView,
            duration:0.25,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {
                self.stateImageView.image = self.stateImages[state.rawValue]
            },
            completion: nil)
    }
    
    func touchAnimation() {
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.heightConstraint.constant = self.maxheightConstraint
            self.view.layoutIfNeeded()
            }, completion: { finished in
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.heightConstraint.constant = self.minheightConstraint
                    self.view.layoutIfNeeded()
                    }, completion: nil)
        })
    }
}