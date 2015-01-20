//
//  LocationController.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    dynamic var status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    dynamic var speed:CLLocationSpeed
    dynamic var direction: CLLocationDirection
    dynamic var currentLocation:CLLocation
    
    override init() {
        self.speed = 0
        self.direction = 0
        self.currentLocation = CLLocation();
        
        super.init();
        
        //check for permissions
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization();
        
        //saving battery
        self.locationManager.pausesLocationUpdatesAutomatically = true

        //specifying activity type as fitness
        self.locationManager.activityType = CLActivityType.Fitness
    
    }
    
    
    func checkPermissions(){
        if(CLLocationManager.headingAvailable())
        {   self.locationManager.headingFilter = 5
            self.locationManager .startUpdatingHeading()
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
           self.direction = newHeading.trueHeading
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        self.status = status
        println("status changed \(self.status)")
        if(status == CLAuthorizationStatus.Authorized || status == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            self.locationManager.startUpdatingLocation()
        }
    }

    /**This method will be use to track user's location*/
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        self.speed = newLocation.speed
        self.currentLocation = newLocation
        println("Speed Updated \(newLocation.speed)");
        //here we need to pass the speed to the observer interested in it.
    }
}
