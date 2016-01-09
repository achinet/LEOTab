import UIKit

@IBDesignable class BaseDesignable: UIView {
    
    //MARK: Nib vars
    var view: UIView!
    private var nibName: String = ""
    
    //MARK: Init
    //This is an abstract class (this in not going to being used)
    override init(frame: CGRect) {
        fatalError("init(coder:nibName:) has not been implemented")
    }
    
    //This is an abstract class (this in not going to being used)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:nibName:) has not been implemented")
    }
    
    init?(frame: CGRect, nibName: String) {
        super.init(frame: frame)
        
        self.nibName = nibName
        setup()
    }

    init?(coder aDecoder: NSCoder, nibName: String) {
        super.init(coder: aDecoder)
        
        self.nibName = nibName
        setup()
    }

    private func setup() {
        view = loadViewFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.addViewAndConstraints()
        self.setupProperties()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

    //Can be overriden
    func addViewAndConstraints() {
        BaseDesignable.addMissionConstraints(self, content: view, contentInsets: UIEdgeInsetsZero)
    }
    
    //To override
    func setupProperties() {

    }
    
    class func addMissionConstraints(container: UIView, content: UIView, contentInsets: UIEdgeInsets) -> (left: NSLayoutConstraint, top: NSLayoutConstraint, right: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        content.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(content)
        
        let leftConstraint = NSLayoutConstraint(
            item: content,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: contentInsets.left)
        
        let rightConstraint = NSLayoutConstraint(
            item: content,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1,
            constant: -1 * contentInsets.right)

        let topConstraint = NSLayoutConstraint(
            item: content,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: contentInsets.top)
        
        let bottomConstraint = NSLayoutConstraint(
            item: content,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: -1 * contentInsets.bottom)
        
        container.addConstraint(leftConstraint)
        container.addConstraint(rightConstraint)
        container.addConstraint(topConstraint)
        container.addConstraint(bottomConstraint)
        
        return (leftConstraint, topConstraint, rightConstraint, bottomConstraint)
    }
}