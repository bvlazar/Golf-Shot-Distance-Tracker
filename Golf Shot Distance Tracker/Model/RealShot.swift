//
//  RealShot.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/13/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import Foundation
import CoreLocation


// This class reperesents an actual tracked shot used in the tracking view
// Finds the distance in YARDS and returns it

class RealShot {
    
    var startLocation: CLLocation?
    var endLocation: CLLocation?
    
    func getDistance() -> Double {
        
        return startLocation!.distanceFromLocation(endLocation!)*1.09361
    }
    
    
}