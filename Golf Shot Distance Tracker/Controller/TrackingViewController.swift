//
//  TrackingViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 5/13/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class TrackingViewController: UIViewController, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    
    // all the UI elements in this view are intilzed bellow
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!
    
    
    // these are in the "keyboard" when the user clicks the textField
    var picker: UIPickerView! = UIPickerView()
    
    var toolBar: UIToolbar!
    var doneButton: UIBarButtonItem!
    
    
    // database object to let us add shots to the database
    let database = Database()
    
    
    // lets us use location
    let locationManager = CLLocationManager()
    
    
    // keeps track of every location the tracker is at, even when user isnt tracking
    // activly
    
    var allLocations = [CLLocation]()

    
    // repersent the actual shot being tracked
    let currentShot = RealShot()
    
    
    //keeps track if the view is actily tracking a shot
    var isTracking = false
    
    
    
    
    
    // OVVERIDDEN LODAING FUNCTIONS
    
    // sets up delegates, itlaizes all the UI elements to proper settings
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up picker delegate
        picker.delegate = self
        
        // create the toolbar
        toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
        
        
        // create done bar
        doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneAction")
        
        let toolBarItems:[AnyObject] = [doneButton]
        
        toolBar.items = toolBarItems
        
        // set up when the user clicks the textbox to pop up the picker and toolbar
        textField.inputView = picker
        textField.inputAccessoryView = toolBar
        textField.tintColor = UIColor.clearColor()
        
        
        // location stuff you need to do
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 0.1
        locationManager.startUpdatingLocation()
        
        // make button rounded cuz it looks better
        startStopButton.layer.cornerRadius = 5
        
        // intialize yardage label to just a space
        distanceLabel.text! = " "

        
    }
    
    // intialize stuff that needs to be done everytime the view is shown
    // this is needed becuase viewDidLoad only gets called once but this gets called everytime it is shown
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        // check to see if there any clubs in the database
        // if not, show user a ui alert and send them back to the club screen
        
        if database.clubCount() == 0 {
            
            // creates the Club Alert
            let noClubAlert = UIAlertController(title: "No Clubs in Database", message: "You must enter at least one club in the database before tracking", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add button that says "Add Clubs"
            noClubAlert.addAction(UIAlertAction(title: "Add Clubs", style: .Default, handler: { (action: UIAlertAction!) in
                // go to Clubs tab to have user enter at least one club
                tabBarController?.selectedIndex = 0
                
            }))
            // show the alert
            presentViewController(noClubAlert, animated: true, completion: nil)
            
        }

        // make sure to reload the picker in case there was new data
        picker.reloadAllComponents()
        
        
    }
    
    // PICKER VIEW DELEGATE FUNCTIONS
    
    // picker stuff you have to do
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return database.clubCount()
    }
    
    //populates the picker with clubs from the database
    func pickerView(pickerView: UIPickerView, titleForRow row:Int, forComponent component: Int) -> String! {
        
        let allClubs = database.retrieveAllClubs()
        
        return allClubs[row].name
    }
    
    // when the user selects a row, change the textbox
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

            let allClubs = database.retrieveAllClubs()
            textField.text = allClubs[row].name
    }
    
    // LOCATION MANAGER DELEGATE FUNCTION
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // get best current location, thats whu its locations.last
        let currentLocation = locations.last as! CLLocation
        
        // add it to list of all locations known to the app
        allLocations.append(currentLocation)
        
        

        // if we are in the middle of tracking, we need to update distance label
        if isTracking {
            // only update display if the accurcay is good
            if currentLocation.horizontalAccuracy <= 11 {
                
                currentShot.endLocation = currentLocation
                let currentDistance = currentShot.getDistance()
                println(currentLocation.horizontalAccuracy)
                distanceLabel.text = displayDistance(currentDistance)

                
            }
        }
        
    }
    
    // IBACTIONS
    
    // called when big button is pressed
    @IBAction func mainButtonPressed(sender: UIButton) {
        
        // get current button  label
        let buttonLabel = startStopButton.currentTitle!
        
        switch buttonLabel {

        // if button activly says "start tracking" do the following 
        // this means user wants to start tracking and we need to do the following
        case "Start Tracking":
            
            // Check to see if user has enabled location services
            // if he didnt, ask him to enable it, tracking view will not work without location services
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse {
                
                
                // create the alert asking the user
                var noLocationAlert = UIAlertController(title: "Location Services Are Disabled", message: "You must have location services enabled to track shots", preferredStyle: UIAlertControllerStyle.Alert)
                
                noLocationAlert.addAction(UIAlertAction(title: "Enable", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    // open the settings app to allow the user to change his choice mannually
                    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                    
                    
                }))
                self.presentViewController(noLocationAlert, animated: true, completion: nil)
            } else  {
            
                // check to see if the GPS has an accurate fix
                if allLocations.last!.horizontalAccuracy > 11 {
                    
                    // if its not accurate, create an alert to warn the user and ask him if he still wants to start tracking or if he wants to wait
                    var notAccurateAlert = UIAlertController(title: "Location is Not Accurate", message: "The current determined location is not accurate, do you still want to start tracking or wait for better accuracy.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    notAccurateAlert.addAction(UIAlertAction(title: "Start", style: .Default, handler: { (action: UIAlertAction!) in
                        self.startTracking()
                        
                    }))
                    notAccurateAlert.addAction(UIAlertAction(title: "Wait", style: .Default, handler: { (action: UIAlertAction!) in
                        
                       
                    }))
                
                    self.presentViewController(notAccurateAlert, animated: true, completion: nil)
                    
                } else {
                    // if GPS has a good fix, go ahead and start tracking
                    startTracking()
                }
            }

            
        // user wants to stop the trackign of the shot
        case "Stop Tracking":
            stopTracking()

        // this is when the button says 'select club'
        default:
            
            textField.becomeFirstResponder()
            
            initalizeTextField(textField)
        }
        
    }
    
    // This needs to be called so when the textbox opens, the first club is automatcally put in the textbox
    func initalizeTextField(sender: UITextField) {
        
        // if there is already a club that has been prviously selected, put that in the textbox when it opens again
        if textField.text != ""{
            sender.text = textField.text
        } else {
            
            // if not, put the firt club in the database there
            let allClubs = database.retrieveAllClubs()
            sender.text = allClubs.first!.name
        }
        
    }

    //MISC. SPECIAL ORIGINAL FUNCTIONS 
    
    // called when the tracking is started
    func startTracking() {
        
        
        
        textField.enabled = false
        
        // make the button change to say stop tracking and change the background color
        startStopButton.setTitle("Stop Tracking", forState: UIControlState.Normal)
        startStopButton.backgroundColor = UIColor(red: 174/255, green: 43/255, blue: 43/255, alpha: 1)
        
        // set is tracking to true
        isTracking = true
        println(allLocations.last!.horizontalAccuracy)
        
        // set the currentShot start location by getting latest position from allLocations array which has all locations ever known
        currentShot.startLocation = allLocations.last
        
    }
    
    // called when tracking is stoped
    func stopTracking() {
        
        // Allow text field and picker to be shown
        textField.enabled = true
        
        // change appearnce of the button accordingly
        startStopButton.setTitle("Select Club", forState: UIControlState.Normal)
        startStopButton.backgroundColor = UIColor(red: 34/255, green: 87/255, blue: 140/255, alpha: 1)
        
       
        isTracking = false
        
        // add shot to database
        database.addShot(picker.selectedRowInComponent(0), distance: currentShot.getDistance())
        
    }
    
    // when user clicks done on popup picker toolbar, make it go away
    
    func doneAction() {
        
        // close the picker when the user clicks done on its toolbar
        textField.resignFirstResponder()
        
        // when user clicks the done button in the toolbar
        // change it to green and have it say start tracking
        startStopButton.backgroundColor! = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        
        startStopButton.setTitle("Start Tracking", forState: UIControlState.Normal)
        
    }

}
