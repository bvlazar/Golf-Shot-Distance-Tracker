//
//  HistoryTableViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/22/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    let database = Database()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title of the view
        self.title = "Shot History"


    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        return database.retrieveAllShots().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // contruct cell to give to the tableview
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        // get shot to be displayed BUT show in reverse cronological order
        let currentShot = database.retrieveAllShots()[database.retrieveAllShots().count-indexPath.row-1]
        
        
        
        cell.textLabel!.text = currentShot.club!.name
        cell.detailTextLabel!.text = displayDistance(currentShot.distance)

        return cell
    }
    

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
            
        case .Delete:
            
            // delete from database, also makes sure to do reverse cronoligcal
            database.deleteShot(database.retrieveAllShots().count-indexPath.row-1)
            
            // delete
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        default: break
            
        }
    }

}
