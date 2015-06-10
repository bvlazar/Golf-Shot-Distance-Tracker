//
//  AddClubViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/31/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit

class AddClubViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    
    let database = Database()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            textField.becomeFirstResponder()
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        let clubName = textField.text
        
        let button = sender as! UIBarButtonItem
        
        
        if button.tag == 0 {
            return true
        }
        
        if clubName == "" {
            return false
        } else {
            
            if database.clubNameExists(clubName) {
                
                var clubExistsAlert = UIAlertController(title: "Club name already exists", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                clubExistsAlert.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { (action: UIAlertAction!) in
                    
                }))
                self.presentViewController(clubExistsAlert, animated: true, completion: nil)
                
                return false
            } else {
                
                return true
            }
            
        }
        
        
        
    }
    

}
