import UIKit
import LEOTab

class SingleTableViewController: LEOTableViewController {
    var barLabel : UILabel!
    let labelMargin : CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leoNavigationBar = self.navigationController?.navigationBar as? LEONavigationBar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addBarLabel()
        self.removeLeftButton()
        
        barLabel.text = "Scrolling Navigation Bar. Browse and check it fucntionallity. This is the first example for a single tableView"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.leoNavigationBar?.titleLabel.text = "Single list"
        
        let nSNotification = NSNotification(name: "", object: self)
        super.willDisplayCell(nSNotification)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseIdentifier")
        }
        switch indexPath.row {
        case 0:
            cell!.textLabel?.text = "CollectionView with TableViews and CollectionViews"
        default:
            cell!.textLabel?.text = "CollectionView with Menu navigatin system"
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row {
        case 0:
            let cv = sb.instantiateViewControllerWithIdentifier("ExampleCollectionViewController") as! ExampleCollectionViewController
            self.navigationController?.pushViewController(cv, animated: true)
        case 1:
            let cv = sb.instantiateViewControllerWithIdentifier("ExampleCollectionViewController2") as! ExampleCollectionViewController2
            self.navigationController?.pushViewController(cv, animated: true)
        default: break
        }
    }
}

private extension SingleTableViewController {
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
    
    func removeLeftButton() {
        for view in (self.leoNavigationBar?.leftButtonContainer.subviews)! {
            view.removeFromSuperview()
        }
    }
}