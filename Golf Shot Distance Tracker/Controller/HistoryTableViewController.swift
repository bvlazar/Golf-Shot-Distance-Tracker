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
        
        self.title = "Shot History"


    }



    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        
        
        return database.retrieveAllShots().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let currentShot = database.retrieveAllShots()[database.retrieveAllShots().count-indexPath.row-1]
        
        
        
        cell.textLabel!.text = currentShot.club!.name
        cell.detailTextLabel!.text = displayDistance(currentShot.distance)

        return cell
    }
    

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
            
        case .Delete:
            
            // delete from database
            database.deleteShot(database.retrieveAllShots().count-indexPath.row-1)
            
            // delete
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        default: break
            
        }
    }

}
