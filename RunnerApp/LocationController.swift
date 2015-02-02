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
    dynamic var speed: Double
    dynamic var direction: CLLocationDirection
    dynamic var currentLocation:CLLocation
    dynamic var distanceDelta:Double
   
    override init() {
        self.speed = 0
        self.direction = 0
        self.currentLocation = CLLocation();
        self.distanceDelta = 0
        
        super.init();
        
        //check for permissions
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization();
        
        //saving battery
        self.locationManager.pausesLocationUpdatesAutomatically = true

        //specifying activity type as fitness
        self.locationManager.activityType = CLActivityType.Fitness
    }
    
    func stopUpdating(){
        self.locationManager.stopUpdatingLocation();
    }
    
    func startUpdating(){
        self.locationManager.startUpdatingLocation()
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
        if(status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            //self.locationManager.startUpdatingLocation()
        }
    }

    /**This method will be use to track user's location*/
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if(newLocation.distanceFromLocation(oldLocation)<100){
            if(oldLocation == nil){return}
            var timePassed : NSTimeInterval = newLocation.timestamp.timeIntervalSince1970 - oldLocation.timestamp.timeIntervalSince1970
            var distance = newLocation.distanceFromLocation(oldLocation)
            self.speed = distance / timePassed
            self.currentLocation = newLocation
            self.distanceDelta = distance
        }

    }
}
