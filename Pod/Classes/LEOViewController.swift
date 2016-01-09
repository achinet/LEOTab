import UIKit

public class LEOViewController: UIViewController {
    let nc = NSNotificationCenter.defaultCenter()
    var leoNavigationBar : LEONavigationBar?
    
    required override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        SetupViewController()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SetupViewController()
    }

    func SetupViewController() {
        self.navigationItem.title = nil
        nc.addObserver(self, selector: "willDisplayCell:", name: "LEO_willDisplayCell", object: nil)
        nc.addObserver(self, selector: "WillDisappearCell:", name: "LEO_WillDisappearCell", object: nil)
    }
}

extension LEOViewController {
    public func willDisplayCell(notif: NSNotification) {
        guard let _ = notif.object as? LEOViewController
            else { return }
        
        //Do nothing
    }
    
    public func WillDisappearCell(notif: NSNotification) {
        guard let _ = notif.object as? LEOViewController
            else { return }
        
        //To override
    }
}