//
//  ViewController.swift
//  hunta
//
//  Created by Luke Murray on 7/19/16.
//  Copyright © 2016 asleepinthetrees. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    var timer: NSTimer!
    var shouldServerUpdate : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // initiate the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // start getting magnetic headings
        locationManager.startUpdatingHeading()
        
        // set the accuracy of the location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // set a timer to debounce calls to the server by the time interval (first number in call)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.resetServerCallTimer), userInfo: nil, repeats: true)
        shouldServerUpdate = true
        
    }
    
    // when the view appears, make sure the user has authorized the app for location tracking
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // sets should server update to true, so that server calls are made
    func resetServerCallTimer() {
        shouldServerUpdate = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // if the user has authorized us to track their location, start updating their location
    // else show an alert to the user to let them allow constant location tracking in their settings
    func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways:
                locationManager.startUpdatingLocation()
            case .AuthorizedWhenInUse, .Restricted, .Denied, .NotDetermined:
                let alertController = UIAlertController(
                    title: "Background Location Access Disabled",
                    message: "In order to be play the game hunter, please open this app's settings and set location access to 'Always'.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // called every time the locationManager gets a new heading
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // does nothing
    }
    
    // called every time the locationManager gets a new location
    // sends the users current location to the server
    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let currentLocation = manager.location?.coordinate
        
        if shouldServerUpdate! == true {
             ServerHelper.UpdateLocation((currentLocation?.latitude.description)!, longitude: (currentLocation?.longitude.description)!, identifier: UIDevice.currentDevice().identifierForVendor!.UUIDString)
            shouldServerUpdate = false
        }
    }
    


    

    @IBAction func KillButtonPressed(sender: UIButton) {
        let currentLocation = locationManager.location?.coordinate
        let heading = locationManager?.heading?.trueHeading
        ServerHelper.AttemptKill((currentLocation?.latitude.description)!, longitude: (currentLocation?.longitude.description)!, angleRelativeToTrueNorth: heading!, identifier: UIDevice.currentDevice().identifierForVendor!.UUIDString)
        
        // debug statements
        print(currentLocation?.latitude.description)
        print(currentLocation?.longitude.description)
        print(heading!)
    }

}

