import UIKit

public class LEOContentCollectionViewController: UICollectionViewController {
    let nc = NSNotificationCenter.defaultCenter()
    public var leoNavigationBar : LEONavigationBar?
    var scrollNotificationEnabled = true
    
    //MARK: Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SetupViewController()
    }
    
    //MARK: Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        SetupViewController()
    }
    
    func SetupViewController() {
        self.navigationItem.title = nil
        nc.addObserver(self, selector: "willDisplayCell:", name: "LEO_willDisplayCell", object: nil)
    }
    
    public func reloadData() {
        let tmpScrollDelegateEnabled = self.scrollNotificationEnabled
        self.scrollNotificationEnabled = false
        self.collectionView!.reloadData()
        self.scrollNotificationEnabled = tmpScrollDelegateEnabled
    }
}

extension LEOContentCollectionViewController : LEOScrollViewProtocol {
    public func get_LeoNavigationBar() -> UINavigationBar {
        return self.leoNavigationBar!
    }
    
    public func set_LeoNavigationBar(lEONavigationBar : LEONavigationBar) {
        self.leoNavigationBar = lEONavigationBar
    }
    
    public func notificationEnabled(enabled: Bool) {
        self.scrollNotificationEnabled = enabled
    }
    
    public func getScrollView() -> UIScrollView {
        return self.collectionView!
    }

    public func willDisplayCell(notif: NSNotification) {
        guard let _ = notif.object as? LEOContentCollectionViewController
            else { return }
        
        if let letLeoNavigationBar = self.leoNavigationBar {
            var contentInset = self.collectionView!.contentInset
            let beforeContentInset = contentInset.top
            contentInset.top = letLeoNavigationBar.frame.size.height + 20
            self.collectionView!.contentInset = contentInset
            
            if (self.collectionView!.contentSize.height < self.collectionView!.frame.size.height - (leoNavigationBar?.getBackLayerMaxHeight())! - self.collectionView!.contentInset.bottom) { return }
            
            if !(beforeContentInset > (letLeoNavigationBar.getBackLayerMinHeight() + 20) && -self.collectionView!.contentOffset.y >= (letLeoNavigationBar.getBackLayerMinHeight() + 20)) {
                let afterOffsetTop = beforeContentInset - contentInset.top
                var contentOffset = self.collectionView!.contentOffset
                contentOffset.y = self.collectionView!.contentOffset.y + afterOffsetTop
                self.collectionView!.contentOffset = contentOffset
            }
        }
    }
    
    public func WillDisappearCell(notif: NSNotification) {
        guard let _ = notif.object as? LEOContentCollectionViewController
            else { return }
        
        //To override
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