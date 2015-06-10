//
//  Extensions.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/25/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayDistance(distanceInYards: Double) -> String {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isImperial") {
            return String(format: "%.1f", distanceInYards)
        } else {
            return String(format: "%.1f", distanceInYards/1.09361)
        }
        
    }
    
    
}