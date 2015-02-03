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
    dynamic var currentLocation:CLLocation?
    dynamic var distanceDelta:Double
   
    override init() {
        self.speed = 0
        self.direction = 0
       // self.currentLocation: = CLLocation();
        self.distanceDelta = 0
        
        super.init();
        
        //check for permissions
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization();
        self.locationManager.desiredAccuracy = 5
        
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
        if(status == CLAuthorizationStatus.Authorized || status == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            //self.locationManager.startUpdatingLocation()
        }
    }
    
    func filterBadResults(newLocation : CLLocation)->Bool{
        if (newLocation.horizontalAccuracy < 0) {
            return false
        
        }
        if (newLocation.horizontalAccuracy > 66) {
            return false
        }
        
        if (newLocation.verticalAccuracy < 0) {
         //   return false
            
        }
        
        if(self.currentLocation != nil){
            var timePassed : NSTimeInterval = newLocation.timestamp.timeIntervalSince1970 - self.currentLocation!.timestamp.timeIntervalSince1970
            var tempDistance = newLocation.distanceFromLocation(self.currentLocation)

            var newSpeed = tempDistance / timePassed
            println("\(newSpeed)")

            if((newSpeed - self.speed) > 4) {return false}
            
            
        }
        
        //Bool
        return true
    }
    

    /**This method will be use to track user's location*/
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
       
        var tempDistance = newLocation.distanceFromLocation(oldLocation)
        if(tempDistance < 15){
            if(oldLocation == nil){return}
            if(newLocation == nil){return}
            if(!self.filterBadResults(newLocation)) {return}
            
            var timePassed : NSTimeInterval = newLocation.timestamp.timeIntervalSince1970 - oldLocation.timestamp.timeIntervalSince1970
            var newSpeed = tempDistance / timePassed
            self.speed = tempDistance / timePassed

            self.currentLocation = newLocation
            self.distanceDelta = tempDistance
            
        }
        else{
           println("\(tempDistance)")
        }

    }
}
