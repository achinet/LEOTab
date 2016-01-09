import UIKit
import LEOTab

class ShortTableViewController: LEOTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseIdentifier")
        }
        cell!.textLabel?.text = "Example row \(indexPath.row)"

        return cell!
    }
}

extension ShortTableViewController { //LEOScrollViewProtocol
    override func willDisplayCell(notif: NSNotification) {
        super.willDisplayCell(notif)
        
        guard let _ = notif.object as? ShortTableViewController else { return }
        
        self.leoNavigationBar?.titleLabel.text = "Short list"
    }
}