//
//  RunController.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

enum runstate{
    case active
    case stopped
    case paused
}

enum measurements{
    case mph
    case kph
}

enum lengths : Double{
    case km = 1000.0
    case mile = 1687.0
}


protocol RunProtocol{
    func speedUpdated(speed:String)
    func distanceUpdated(distance:String)
    func timeUpdated(time:String)
    func statusUpdated(status: CLAuthorizationStatus)
    func stateUpdated(state:runstate)
}

class RunController: NSObject {
    var currentRunIndex: Int
    var speedMode:measurements
    var speed:Double
    var time:Int
    var timer:NSTimer
    var distance:Double
    var state : runstate{
        didSet{
            for observer in self.observers {
                observer.stateUpdated(self.state)
            }

        }
    
    } //= runstate.stopped
    
    var observers: [RunProtocol] = []
    var locationStatus  : CLAuthorizationStatus
    private var locationController:LocationController =  LocationController()
 
    func addRunObserver(observer:RunProtocol){
        self.observers.append(observer)
    }
    
    func getDistance(rawDistance:Double)->String{
        var km = round (100 * self.distance/lengths.km.rawValue )/100
        var miles = round (100 * self.distance/lengths.mile.rawValue )/100
        
        var displayText = ""
        if(self.speedMode == measurements.kph)
        {
            displayText = "\(km)"
        }
        else{
            displayText = "\(miles)"
        }
        return displayText
    }
    

    
    override init() {
        self.currentRunIndex = -1
        self.speedMode = measurements.kph
        self.speed = 0
    
        self.time = 0
        self.timer = NSTimer();
        self.distance = 0
        self.locationStatus = self.locationController.status
        self.state = runstate.stopped

        super.init()
    
        locationController.addObserver(self, forKeyPath: "status", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "speed", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "distanceDelta", options:.New , context: nil)
        
        self.addObserver(self, forKeyPath: "state", options:.New , context: nil)
        self.locationController.startUpdating();
        
    }
    
    func start(){
        //create new run
        self.locationController.startUpdating()

        if(self.state == runstate.paused){
            self.resume()
            return
        }
        
        if(self.state == runstate.stopped){
            self.time = 0
            self.distance = 0.0
            
        }

        if !self.timer.valid
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true);
            
            var nsrunloop = NSRunLoop();
            nsrunloop.addTimer(self.timer, forMode: NSRunLoopCommonModes)

        }
        self.state = runstate.active
  
    }
    
    func timerTick()->Void
    {
        self.time += 1
        var displayText = convertTimeToText(self.time)
        for observer in self.observers {
            observer.timeUpdated(displayText)
        }
    }
    
    func stop(){
        //stop running
        self.time = 0
        self.timer.invalidate()
        self.state = runstate.stopped
        
        //self.locationController.stopUpdating();
    }
    
    func pause(){
        //pause running
        self.timer.invalidate();
        self.state = runstate.paused
        //self.locationController.stopUpdating();
    }
    
    func resume(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true);
        
        var nsrunloop = NSRunLoop();
        nsrunloop.addTimer(self.timer, forMode: NSRunLoopCommonModes)
        self.state = runstate.active
          self.locationController.startUpdating();
    }

    func calculateSpeed(speed: Double)->Double{
            switch self.speedMode {
        case measurements.kph:
            return round(10 * speed * 3600.0 / lengths.km.rawValue) / 10

        case measurements.mph:
            return round( 10 * speed * 3600.0 / lengths.mile.rawValue) / 10
    

       // default: return speed
        }
        
    }
    
    func changeMeasurements(){
        self.speedMode = (self.speedMode == measurements.kph ) ? measurements.mph : measurements.kph
        
    }
    
    func createNewRun(){
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
 }
    
    
    func convertTimeToText(time:Int)->String{
        var hours = time/(3600)
        var minutes = (time/60) - (hours * 60)
        var seconds = time%60
        var displayTime = ""
        if(hours < 10) {
            
            displayTime = "\(hours):"
            if(hours == 0){
                displayTime = ""
            }
            
            if(minutes < 10 ) {
                displayTime = "\(displayTime)0\(minutes):"
            }
            else{
                displayTime = "\(displayTime)\(minutes):"
            }
            
            if(seconds < 10 ) {
                displayTime = "\(displayTime)0\(seconds)"
            }
            else{
                displayTime = "\(displayTime)\(seconds)"
            }
            
            
            
        }
        else{
            displayTime = "\(hours)"
        }
        return displayTime
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "status"){
               // self.checkPermissions()
            self.locationStatus = self.locationController.status
            //notify observers
            for observer in self.observers {
                observer.statusUpdated(self.locationStatus)
            }
        }
        
        if(keyPath == "speed"){
            //update speed
            var rawSpeed: Double  = change[NSKeyValueChangeNewKey] as Double
            self.speed = rawSpeed
            var localizedSpeed = calculateSpeed(self.speed)
          
            var displayText = "\(localizedSpeed)"
            
            for observer in self.observers {
                observer.speedUpdated(displayText)
            }
        }
        
        if(keyPath == "distanceDelta"){
            //update speed
            //self.runController.distance
            if(self.state != runstate.active) { return }
            
            var newDistance: Double  = change[NSKeyValueChangeNewKey] as Double
            self.distance = self.distance + newDistance
            for observer in self.observers {
                observer.distanceUpdated(getDistance(self.distance))
            }
        }
        if(keyPath == "state"){
            for observer in self.observers {
                observer.stateUpdated(self.state)
            }
    
        }
        
    }
    
    
}


