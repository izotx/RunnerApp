//
//  RunController.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit
import CoreData

enum runstate{
    case active
    case stopped
    case paused
}

enum measurements{
    case mph
    case kph
}

protocol RunProtocol{
    func speedUpdated(speed:Double)
    func distanceUpdated(distance:Double)
    func timeUpdated(time:Int)
}

class RunController: NSObject {
    var currentRunIndex: Int
    var speedMode:measurements
    var speed:Double
    var time:Int
    var timer:NSTimer
    var distance:Double
    var state : runstate = runstate.stopped
    var observers: [RunProtocol] = []

    private var locationController:LocationController =  LocationController()
    func addRunObserver(observer:RunProtocol){
        self.observers.append(observer)
    }
    
    override init() {
        self.currentRunIndex = -1
        self.speedMode = measurements.kph
        self.speed = 0
        self.time = 0
        self.timer = NSTimer();
        self.distance = 0
    
        super.init()
    
        locationController.addObserver(self, forKeyPath: "status", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "speed", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "distanceDelta", options:.New , context: nil)

    }
    
    func start(){
        //create new run
        if self.timer.valid
        {
            self.timer.invalidate()
        }
        self.time = 0
        self.distance = 0
            
        self.timer = NSTimer(timeInterval: 1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true)
    }
    
    func timerTick(timer: NSTimer)->Void
    {
        self.time += 1
    }
    
    func finish(){
        //stop running
        self.timer.invalidate();
    }
    
    func pause(){
        //pause running
        self.timer.invalidate();
        
    }
    
    func resume(){

        self.timer = NSTimer(timeInterval: 1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true)
    }
    
    func updateDistance(distance:Double){
        
    }
    

    func calculatedSpeed(speed: Double)->Double{
        switch self.speedMode {
        case measurements.kph:
                return speed * 3600/1000

        case measurements.kph:
            return speed * 3600/1687
    

        default: return speed
        }
        
    }
    
    func changeMeasurements(mode: measurements){
        self.speedMode = mode
    }
    
    func createNewRun(){
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
 }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "status"){
               // self.checkPermissions()
        }
        
        if(keyPath == "speed"){
            //update speed
            var speed: Double  = change[NSKeyValueChangeNewKey] as Double

        }
        
        if(keyPath == "distanceDelta"){
            //update speed
            //self.runController.distance
        }
        
        
    }
    
    
}


