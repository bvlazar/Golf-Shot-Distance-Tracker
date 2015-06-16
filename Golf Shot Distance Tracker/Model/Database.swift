//
//  Database.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/13/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import Foundation
import RealmSwift


// is a shot in the database.
class Shot: Object {
    
    dynamic var club: Club?
    dynamic var distance = 108.4
    dynamic var date = NSDate()
}

// is a club in the database
// a club has many shots assosiated with it
class Club: Object {
    
    dynamic var name = "9 iron"
    
    let distances = List<Shot>()
    
    var owner: Clubs?

}

// used to reperesent all clubs in database. 
// purpose is to keep the right order of clubs
class Clubs: Object {
    let list = List<Club>()
}

class Database {
    
    let realm = Realm()
    
    init() {
        
        // if there is no Clubs object
        if realm.objects(Clubs).count == 0 {
            
            
            // create the Clubs object to put clubs in
            let clubList = Clubs()
            
            realm.beginWrite()
            realm.add(clubList)
            realm.commitWrite()
        }
    }
    
    // adds a club to the database with just a name
    func addClub(name: String) {
        let newClub = Club()
        
        let clubs = realm.objects(Clubs).first!
        
        
        newClub.name = name
        
        newClub.owner = clubs
        
        realm.beginWrite()
        realm.add(newClub)
        clubs.list.append(newClub)
        realm.commitWrite()
        
        
    }
    
    // deletes club from database
    func deleteClub(id: Int) {
        
        let toDelete = realm.objects(Clubs).first!.list[id]
        let shotsToDelete = realm.objects(Shot).filter("club.name='\(toDelete.name)'")
        realm.beginWrite()
        realm.delete(shotsToDelete)
        realm.delete(toDelete)
        realm.commitWrite()
    }
    
    //  adds a shot to the database
    func addShot(clubIndex: Int, distance: Double) {
        // create a new shot and get club that was hit with it
        let newShot = Shot()
        let club = realm.objects(Clubs).first!.list[clubIndex]
        
        // contruct new shot with properties
        newShot.distance = distance
        newShot.date = NSDate()
        newShot.club = club
        
        
        realm.beginWrite()
        // add shot to right club
        club.distances.append(newShot)
        
        // add shot to database
        realm.add(newShot)
        
        realm.commitWrite()
        
        
    }
    
    // deletes given shot
    func deleteShot(id: Int) {
        
        let toDelete = realm.objects(Shot)[id]
        
        realm.beginWrite()
        realm.delete(toDelete)
        realm.commitWrite()
        
    }
    
    // rearange the clubs given a specific club, start and end index
    func updateClubList(club: Club, startIndex: Int, endIndex: Int) {
        
        let clubs = realm.objects(Clubs).first!.list
        
        realm.beginWrite()
        clubs.removeAtIndex(startIndex)
        clubs.insert(club, atIndex: endIndex)
        
        realm.commitWrite()
        
        println(clubs)
        
    }
    
    // gets a result list of all clubs currently in the database
    func retrieveAllClubs() -> List<Club> {
        
        let allClubs = realm.objects(Clubs).first!.list

        return allClubs
        
    }
    
    // retrives all clubs but as a list object
    func retrieveClubsAsList() -> List<Club> {
        
        var allClubs = retrieveAllClubs()
        
        var list = List<Club>()
        
        for club in allClubs {
            list.append(club)
        }
        return list
        
    }
    

    // retrieves all shots as a results object
    func retrieveAllShots() -> Results<Shot> {
        let allShots = realm.objects(Shot)
        return allShots
        
    }
    
    // delets shots given a club name
    func deleteShots(name: String) {
        
        let shotsToDelete = realm.objects(Shot).filter("club.name='\(name)'")
        
        realm.beginWrite()
        realm.delete(shotsToDelete)
        realm.commitWrite()
        
        
    }
    
    
    // deletes all shots in database, used for reset
    func deleteAllShots() {
        let allShots = retrieveAllShots()
        
        realm.beginWrite()
        realm.delete(allShots)
        realm.commitWrite()
    }
    
    // returns club object from string
    func getClub(name: String) -> Club {
        let club = realm.objects(Club).filter("name = '\(name)'")
        
        return club.first!
        
    }
    
    // number of clubs in the database
    func clubCount() -> Int {
        return realm.objects(Clubs).first!.list.count
    }
    

    
    // checks to see if a club name is already in the database
    // please use before addClub()
    func clubNameExists(name: String) -> Bool {
        let club = realm.objects(Club).filter("name = '\(name)'")
        
        if club.count == 0 {
            return false
        }
        else {
            return true
        }
        
    }

}