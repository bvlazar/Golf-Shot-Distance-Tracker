//
//  ViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/13/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var navigationBar: UINavigationItem!

    
    let database = Database()

    var clubEditList: List<Club>?
    
    
    
    @IBAction func cancelToClubView(segue: UIStoryboardSegue) {
        
    }
    @IBAction func addClub(segue: UIStoryboardSegue) {
        
        
        if let vc = segue.sourceViewController as? AddClubViewController {
            
            let clubName = vc.textField.text
                
            
            // add name to database to database and reload tableView
            self.database.addClub(clubName)
            self.tableView.reloadData()
                

            
        }

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.delegate = self
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if the user clicks on a specfic club, we are going to show the detail VC
        if segue.identifier == "showDetail" {
            
            // get next VC
            let destinationViewController = segue.destinationViewController as! ClubDetailViewController
            
            // set the index of the club in next VC for details
            destinationViewController.index = tableView.indexPathForSelectedRow()!.row
            
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.clubCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // creates a cell from ClubTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("ClubCell") as! UITableViewCell
        
        // get all clubs to index
        let allClubs = database.retrieveAllClubs()
        
        //pull out name of club from allClubs with index
        let clubName = allClubs[indexPath.row].name
        
        let clubStats = Statistics(name: clubName)
        
        //insert real club distance code here
        let clubDistance = clubStats.getClubDistanceAverage()
        
        
        //set the proper text and then return
        cell.textLabel!.text = clubName
        cell.detailTextLabel!.text = displayDistance(clubDistance)
        
        return cell

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // deals with deleting rows from the table view
        switch editingStyle {
            
        case .Delete:
            
            // delete from database
            
            database.deleteClub(indexPath.row)
            
            // delete
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        default: break

        }
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.editing {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.None
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let clubMoved = database.retrieveAllClubs()[sourceIndexPath.row]
        
        
        
        database.updateClubList(clubMoved, startIndex: sourceIndexPath.row, endIndex: destinationIndexPath.row)
        
        
        
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
       super.setEditing(editing, animated: animated)
        
    }

}

