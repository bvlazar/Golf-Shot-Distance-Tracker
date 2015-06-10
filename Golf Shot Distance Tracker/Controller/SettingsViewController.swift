//
//  SettingsViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/24/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var unitControl: UISegmentedControl!
    
    let database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isImperial") {
            
            unitControl.selectedSegmentIndex = 0
            
        } else {
            
            unitControl.selectedSegmentIndex = 1
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let resetButton = UIAlertAction(title: "Delete All Shots", style: .Destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                
                self.database.deleteAllShots()
                
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            
            optionMenu.addAction(resetButton)
            optionMenu.addAction(cancelButton)
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func unitChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isImperial")
        case 1:
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isImperial")
        default:
            break
        }
        
    }

    
    
    

}
