import UIKit

public class LEOTableViewController: UITableViewController {
    let nc = NSNotificationCenter.defaultCenter()
    var leoNavigationBar : LEONavigationBar?
    var scrollNotificationEnabled = true
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SetupViewController()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        SetupViewController()
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        SetupViewController()
    }
    
    func SetupViewController() {
        self.navigationItem.title = nil
        nc.addObserver(self, selector: "willDisplayCell:", name: "LEO_willDisplayCell", object: nil)
    }
    
    public func reloadData() {
        let tmpScrollDelegateEnabled = self.scrollNotificationEnabled
        self.scrollNotificationEnabled = false
        self.tableView.reloadData()
        self.scrollNotificationEnabled = tmpScrollDelegateEnabled
    }
    
    //MARK: ScrollViewDelegate
    override public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollNotificationEnabled {
            nc.postNotificationName("LEO_scrollViewWillBeginDragging", object: self)
        }
    }
    
    override public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollNotificationEnabled {
            nc.postNotificationName("LEO_scrollViewDidEndDragging", object: self)
        }
    }
    
    override public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if scrollNotificationEnabled {
            nc.postNotificationName("LEO_scrollViewWillBeginDecelerating", object: self)
        }
    }
    
    override public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollNotificationEnabled {
            nc.postNotificationName("LEO_scrollViewDidEndDecelerating", object: self)
        }
    }
    
    override public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollNotificationEnabled {
            nc.postNotificationName("LEO_scrollViewDidScroll", object: self)
        }
    }
}

extension LEOTableViewController { //As UICollectionViewCell
    public func willDisplayCell(notif: NSNotification) {
        guard let _ = notif.object as? LEOTableViewController
            else { return }
        
        if let letLeoNavigationBar = self.leoNavigationBar {
            var contentInset = self.tableView.contentInset
            let beforeContentInset = contentInset.top
            contentInset.top = letLeoNavigationBar.frame.size.height + 20
            self.tableView.contentInset = contentInset
            
            if (self.tableView.contentSize.height < self.tableView.frame.size.height) { return }
            
            if !(beforeContentInset > (letLeoNavigationBar.getBackLayerMinHeight() + 20) && -self.tableView.contentOffset.y >= (letLeoNavigationBar.getBackLayerMinHeight() + 20)) {
                let afterOffsetTop = beforeContentInset - contentInset.top
                var contentOffset = self.tableView.contentOffset
                contentOffset.y = self.tableView.contentOffset.y + afterOffsetTop
                self.tableView.contentOffset = contentOffset
            }
        }
    }
}