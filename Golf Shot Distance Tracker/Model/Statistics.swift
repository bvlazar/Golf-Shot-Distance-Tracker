//
//  ClubStatistics.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/14/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import Foundation
import RealmSwift

// This class gives various statistcs realted to a specific club


class Statistics {

    
    
    
    
    let clubName: String?
    let club:Club!
    
    let database = Database()
    
    // Must intialize with a string of the club name
    init(name: String) {
        
       clubName = name
        
        club = database.getClub(clubName!)
        
    }
    
    
    // returns the average distance of the club

    func getClubDistanceAverage() -> Double {
        
        var total: Double = 0

        for shot in club.distances {
            
            total = total + shot.distance
            
        }
        
        if club.distances.count == 0 {
            
            return 0
        }
        else {

            return total / Double(club.distances.count)
        }
    }
    
    // get minimum distnace of specific club
    func getRangeClubDistance(end: String) -> Double {

        if club.distances.count == 0 {
            
            return 0
        }
        else {
            // sort the shots
            
            let sortedShots = club.distances.sorted("distance", ascending: true)
            
            if end == "min" {
                return sortedShots.first!.distance
            } else {
                return sortedShots.last!.distance
            }
            
        }
        
    }
    
    // returns percentile club distance from a double 0 to 1
    // EX. 0.25 returns 25th percentile distance
    func getPercentileClubDistance(percentile: Double) -> Double {

        if club.distances.count == 0 {
            
            return 0
        }
        else {
            
            let sortedShots = club.distances.sorted("distance", ascending: true)
            
            let index = Int(ceil(Double(sortedShots.count)*percentile))-1

            return sortedShots[index].distance
        }
        
        
    }
    

}