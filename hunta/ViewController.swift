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
        locationManager.startUpdatingLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // called every time the locationManager gets a new heading
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.trueHeading)
    }
    
    // called every time the locationManager gets a new location
    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations = \(locations)")
    }
    
    // get the location authorization
    


}

