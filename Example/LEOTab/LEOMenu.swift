import UIKit

enum ButtonSeparatorImage {
    case Small
    case Large
}

extension ButtonSeparatorImage {
    var imageNamed : String {
        switch self {
        case .Small:
            return "wizard_2_points"
        case .Large:
            return "wizard_3_points"
        }
    }
    
    var size: CGSize {
        switch self {
        case .Small:
            return CGSizeMake(13, 3)
        case .Large:
            return CGSizeMake(23, 3)
        }
    }
    
    static func getSize(numItems: Int) -> ButtonSeparatorImage {
        return numItems < 5 ? .Large : .Small
    }
}

protocol LEOMenuProtocol {
    func buttonClicked(num: Int)
}

class LEOMenu: UIView {
    var delegate:LEOMenuProtocol?
    
    private let buttonDim : CGFloat = 41
    private let lateralMargin : CGFloat = 10
    var _buttonsArray = [LEOMenuButton]()
    private var _separatorsArray = [UIImageView]()
    
    var currentButtonIndex : Int? {
        get {
            return getButtonOrder(findCurrentButton())
        }
    }
    
    var stateImages : [[UIImage]]! {
        didSet {
            if _buttonsArray.count > 0 {
                for button in _buttonsArray {
                    button.removeFromSuperview()
                }
                _buttonsArray.removeAll()
            }
            
            if _separatorsArray.count > 0 {
                for separator in _separatorsArray {
                    separator.removeFromSuperview()
                }
                _separatorsArray.removeAll()
            }
            setupButtons(stateImages)
        }
    }
    
    //MARK: INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStates(states : [LEOMMenuButtonStates]) {
        for index in 0..<_buttonsArray.count {
            _buttonsArray[index].setState(states[index], animated: false)
        }
    }
    
    func stretchButtons(factor : CGFloat) {
        findCurrentButton().stretch(factor)
    }
    
    func setState(state : LEOMMenuButtonStates, ToButtonNum num : Int, animated: Bool) {
        _buttonsArray[num].setState(state, animated: animated)
    }
    
    func performClick(clickedIndex: Int) {
        let sender = _buttonsArray[clickedIndex]
        if sender.state == LEOMMenuButtonStates.inaccesible { return }
        let currentButton = findCurrentButton()
        if currentButton == sender { return }
        
        if let letDelegate = self.delegate {
            letDelegate.buttonClicked(clickedIndex)
        }
    }
    
    func animateButtonClick(currentIndex: Int, clickedIndex: Int) {
        if currentIndex < clickedIndex {
            self._buttonsArray[currentIndex].setState(LEOMMenuButtonStates.done, animated: true)
        }
        else {
            self._buttonsArray[currentIndex].setState(LEOMMenuButtonStates.accesibleEmpty, animated: true)
        }
        self._buttonsArray[clickedIndex].setState(LEOMMenuButtonStates.current, animated: true)
    }
}

private extension LEOMenu {
    func setupButtons(stateImages:[[UIImage]]) {
        self.buildLayouts(stateImages)
        self.addSubviewsAndConstraints()
        self.setupProperties()
    }
    
    func buildLayouts(stateImages:[[UIImage]]) {
        for index in 0..<stateImages.count {
            let uPMenuButton = LEOMenuButton(frame: CGRectMake(0, 0, buttonDim, buttonDim))
            uPMenuButton.stateImages = stateImages[index]
            _buttonsArray.append(uPMenuButton)
        }
        
        let separatorWidth = ButtonSeparatorImage.getSize(stateImages.count).size.width
        for _ in 0..<(stateImages.count - 1) {
            let tmpSeparatorView = UIImageView(frame: CGRectMake(0, 0, separatorWidth, 3))
            tmpSeparatorView.image = UIImage(named: ButtonSeparatorImage.getSize(stateImages.count).imageNamed)
            _separatorsArray.append(tmpSeparatorView)
        }
    }
    
    func buttonMargin(numButtons: Int) -> CGFloat {
        let numButtonsFloat = CGFloat(numButtons)
        let separatorWidth = ButtonSeparatorImage.getSize(numButtons).size.width
        return (UIScreen.mainScreen().bounds.size.width - 2 * lateralMargin - numButtonsFloat * buttonDim - (numButtonsFloat - 1) * separatorWidth)/(2 * numButtonsFloat - 2)
    }
    
    func addSubviewsAndConstraints() {
        for menuButton in _buttonsArray {
            menuButton.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(menuButton)
        }
        
        for separator in _separatorsArray {
            separator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(separator)
        }
        
        var viewsDictionary = [String : AnyObject]()
        for index in 0..<_buttonsArray.count {
            viewsDictionary["button\(index)"] = _buttonsArray[index]
        }
        
        for index in 0..<_separatorsArray.count {
            viewsDictionary["separator\(index)"] = _separatorsArray[index]
        }
        
        let metricsDictionary = ["buttonDim": buttonDim, "separatorDim": ButtonSeparatorImage.getSize(_buttonsArray.count).size.width, "lateralMargin": self.lateralMargin, "margin": self.buttonMargin(_buttonsArray.count)]
        
        var constraintStringH = "H:|-(lateralMargin)-"
        for index in 0..<(_buttonsArray.count - 1) {
            constraintStringH = constraintStringH + "[button\(index)(buttonDim)]-(margin)-[separator\(index)(separatorDim)]-(margin)-"
        }
        
        constraintStringH = constraintStringH + "[button\(_buttonsArray.count - 1)(buttonDim)]-(lateralMargin)-|"
        
        let constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(constraintStringH,
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDictionary,
            views: viewsDictionary)
        
        self.addConstraints(constraint_H)
        
        for button in _buttonsArray {
            let constraintButtonVerticalCenter = NSLayoutConstraint(
                item: button,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1,
                constant: -2)
            self.addConstraint(constraintButtonVerticalCenter)
        }
        
        for separator in _separatorsArray {
            let constraintButtonVerticalCenter = NSLayoutConstraint(
                item: separator,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1,
                constant: -2)
            self.addConstraint(constraintButtonVerticalCenter)
        }
    }
    
    func setupProperties() {
        for button in _buttonsArray {
            button.delegate = self
        }
    }
    
    func findCurrentButton() -> LEOMenuButton {
        for button in _buttonsArray {
            if button.state == LEOMMenuButtonStates.current { return button }
        }
        return _buttonsArray[0]
    }
    
    func getButtonOrder(button: LEOMenuButton) -> Int {
        for index in 0..<_buttonsArray.count {
            if button == _buttonsArray[index] {
                return index
            }
        }
        return 0
    }
}

extension LEOMenu : LEOMenuButtonProtocol {
    func clicked(sender: LEOMenuButton) {
        self.performClick(getButtonOrder(sender))
    }
}