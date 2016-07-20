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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // initiate the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // start getting magnetic headings
        locationManager.startUpdatingHeading()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // MARK: - location manager to authorize user location for Maps app
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
        //print(newHeading.trueHeading)
    }
    
    // called every time the locationManager gets a new location
    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = manager.location?.coordinate
        
        print(currentLocation!)
        print(locationManager!.heading?.trueHeading)
        
        ServerHelper.UpdateLocation((currentLocation?.latitude.description)!, longitude: (currentLocation?.longitude.description)!, identifier: UIDevice.currentDevice().identifierForVendor!.UUIDString)

    }
    


}

