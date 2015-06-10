//
//  ClubDetailViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/20/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit

class ClubDetailViewController: UITableViewController, UITableViewDataSource {
    
    
    
    
    
    // this is set in the parent VC
    var index: Int = 0
    var stats: Statistics!
    
    var clubName: String!
    
    let database = Database()
    
    
    @IBOutlet weak var meanLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var percentile25Label: UILabel!
    @IBOutlet weak var medianLabel: UILabel!
    @IBOutlet weak var percentile75Label: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clubName = database.retrieveAllClubs()[index].name
        
        // make title == to name of club that was selected in previous VC
        self.title = clubName
        
        // create statistics object to retrive club statistics
        stats = Statistics(name: clubName)
        
        meanLabel.text! = displayDistance(stats.getClubDistanceAverage())
        minLabel.text! = displayDistance(stats.getRangeClubDistance("min"))
        percentile25Label.text! = displayDistance(stats.getPercentileClubDistance(0.25))
        medianLabel.text! = displayDistance(stats.getPercentileClubDistance(0.5))
        percentile75Label.text! = displayDistance(stats.getPercentileClubDistance(0.75))
        maxLabel.text! = displayDistance(stats.getRangeClubDistance("max"))
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        

        
    }
    
    @IBAction func resetClub(sender: UIBarButtonItem) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let resetButton = UIAlertAction(title: "Reset Club", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.database.deleteShots(self.clubName)
            self.viewDidLoad()
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(resetButton)
        optionMenu.addAction(cancelButton)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        
    }
    
}
