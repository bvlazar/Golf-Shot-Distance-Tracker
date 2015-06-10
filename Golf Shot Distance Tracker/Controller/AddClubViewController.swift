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

        // open up keyboard as soon as the view loads
        textField.becomeFirstResponder()
    }


    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        // if user clicks on the row, open up the keyboard
        if indexPath.row == 0 {
            textField.becomeFirstResponder()
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        let clubName = textField.text
        
        let button = sender as! UIBarButtonItem
        
        // if they pressed cancel, segue from this view and cancel opperation
        if button.tag == 0 {
            return true
        }
        // dont let user go away if they didnt enter any text for a club name
        if clubName == "" {
            return false
        } else {
            // if they click done, check to see if club is in the database
            if database.clubNameExists(clubName) {
                // if it is, show an alert to tell them to try again
                var clubExistsAlert = UIAlertController(title: "Club name already exists", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                clubExistsAlert.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { (action: UIAlertAction!) in
                    
                }))
                self.presentViewController(clubExistsAlert, animated: true, completion: nil)
                
                // do not segue in this case
                return false
            } else {
                // if all other of those tests pass, segue from this screen
                return true
            }
            
        }
        
        
        
    }
    

}
