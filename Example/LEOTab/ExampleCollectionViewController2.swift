import UIKit
import LEOTab

private let reuseIdentifier = "Cell"

class ExampleCollectionViewController2: LEOCollectionViewController {
    var buttonDim : CGFloat = 50.0
    var buttomMargin : CGFloat = 0
    var menu : LEOMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.scrollEnabled = false
        self.collectionView.pagingEnabled = false
        
        self.addLeftButton()
        self.addMenu()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.controllers = [sb.instantiateViewControllerWithIdentifier("ShortTableViewController") as! ShortTableViewController,
            sb.instantiateViewControllerWithIdentifier("LargeTableViewController") as! LargeTableViewController,
            sb.instantiateViewControllerWithIdentifier("LargeTableViewController") as! LargeTableViewController,
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

private extension ExampleCollectionViewController2 {
    func addLeftButton() {
        let leftButton = UIButton(type: UIButtonType.Custom)
        leftButton.frame = CGRectMake(buttomMargin, buttomMargin, buttonDim, buttonDim)
        leftButton.imageView?.contentMode = UIViewContentMode.Center
        leftButton.setImage(UIImage(named:"nav_bar_back"), forState: .Normal)
        leftButton.addTarget(self, action: "leftPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.leoNavigationBar!.leftButtonContainer.addSubview(leftButton)
    }
    
    func addMenu() {
        for view in (self.leoNavigationBar?.bottomLayer.subviews)! {
            view.removeFromSuperview()
        }
        menu = LEOMenu(frame: CGRectMake(0, 8, UIScreen.mainScreen().bounds.size.width, 30))
        menu.backgroundColor = UIColor.clearColor()
        
        let stateImages : [[UIImage]]? = [
            [
                UIImage(named: "wizard_map")!,
                UIImage(named: "wizard_map_active")!,
                UIImage(named: "wizard_map_done")!,
                UIImage(named: "wizard_map")!,
                UIImage(named: "wizard_map_done")!
            ],
            [
                UIImage(named: "wizard_shopping_bag")!,
                UIImage(named: "wizard_shopping_bag_active")!,
                UIImage(named: "wizard_shopping_bag_done")!,
                UIImage(named: "wizard_shopping_bag")!,
                UIImage(named: "wizard_shopping_bag_done")!
            ],
            [
                UIImage(named: "wizard_details")!,
                UIImage(named: "wizard_details_active")!,
                UIImage(named: "wizard_details_done")!,
                UIImage(named: "wizard_details")!,
                UIImage(named: "wizard_details_done")!
            ],
            [
                UIImage(named: "wizard_pay")!,
                UIImage(named: "wizard_pay_active")!,
                UIImage(named: "wizard_pay_done")!,
                UIImage(named: "wizard_pay")!,
                UIImage(named: "wizard_pay_done")!
            ]]
        menu.stateImages = stateImages
        menu.setStates([LEOMMenuButtonStates.current, LEOMMenuButtonStates.accesibleEmpty, LEOMMenuButtonStates.accesibleEmpty, LEOMMenuButtonStates.accesibleEmpty, LEOMMenuButtonStates.accesibleEmpty])
        menu.delegate = self
        self.leoNavigationBar?.bottomLayer.addSubview(menu)
    }
}

extension ExampleCollectionViewController2 : LEOMenuProtocol {
    func buttonClicked(num: Int) {
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: num, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
}

extension ExampleCollectionViewController2 {
    internal override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        menu.animateButtonClick(indexPath.row, clickedIndex: (getCurrentIndexPath()?.row)!)
    }
}
