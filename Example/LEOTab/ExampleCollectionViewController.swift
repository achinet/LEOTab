import UIKit
import LEOTab

private let reuseIdentifier = "Cell"

class ExampleCollectionViewController: LEOCollectionViewController {
    var buttonDim : CGFloat = 50.0
    var buttomMargin : CGFloat = 0
    var barLabel : UILabel!
    let labelMargin : CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBarLabel()
        barLabel.text = "TableViews and CollectionViews inside a collectionView. Scroll up and down, and also left and right to see how it works"
        
        self.addLeftButton()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.controllers = [sb.instantiateViewControllerWithIdentifier("ShortTableViewController") as! ShortTableViewController,
                            sb.instantiateViewControllerWithIdentifier("LargeTableViewController") as! LargeTableViewController]
    }
    
    func leftPressed(sender: UIButton) {
        let currentIndexPath = self.getCurrentIndexPath()
        
        if currentIndexPath?.row == 0 {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: ((currentIndexPath?.row)! - 1), inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        }
    }
}

private extension ExampleCollectionViewController {
    func addLeftButton() {
        let leftButton = UIButton(type: UIButtonType.Custom)
        leftButton.frame = CGRectMake(buttomMargin, buttomMargin, buttonDim, buttonDim)
        leftButton.imageView?.contentMode = UIViewContentMode.Center
        leftButton.setImage(UIImage(named:"nav_bar_back"), forState: .Normal)
        leftButton.addTarget(self, action: "leftPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.leoNavigationBar!.leftButtonContainer.addSubview(leftButton)
    }
    
    func addBarLabel() {
        for view in (self.leoNavigationBar?.bottomLayer.subviews)! {
            view.removeFromSuperview()
        }
        barLabel = UILabel(frame: CGRectMake(labelMargin, 0, UIScreen.mainScreen().bounds.width - 2 * labelMargin, (leoNavigationBar!.bottomLayer.frame.size.height)))
        barLabel.numberOfLines = 2
        barLabel.textColor = UIColor.lightGrayColor()
        barLabel.font = UIFont.systemFontOfSize(12)
        leoNavigationBar!.bottomLayer.addSubview(barLabel)
    }
}
