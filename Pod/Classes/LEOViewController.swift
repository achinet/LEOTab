//
//  LEOViewController.swift
//  Pods
//
//  Created by Leonardo Ruiz on 31/12/15.
//
//

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
    }
}

extension LEOViewController { //As UICollectionViewCell
    public func willDisplayCell(notif: NSNotification) {
        guard let _ = notif.object as? LEOViewController
            else { return }
        
        //Do nothing
    }
}