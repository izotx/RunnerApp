//
//  ViewController.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, RunProtocol {
    private var myContext = 0
  
 //   private var locationController:LocationController = LocationController()
    private var runController:RunController = RunController()
    
    @IBOutlet weak var speedometer: SpeedomoterView!
    @IBOutlet weak var startButtonOutlet: startButton!
    @IBOutlet weak var distanceView: DoubleLabel!
    @IBOutlet weak var timer: SingleLabel!
    @IBOutlet weak var speedStateButton: mphButton!
    @IBOutlet weak var stopButtonOutlet: stopButton!
    @IBOutlet weak var pauseButtonOutlet: pauseButton!
   
    
    //Run Protocol
    func speedUpdated(speed: String) {
        self.speedometer.topText = "\(speed)"
        self.speedometer.speed = self.runController.speed

        if(self.runController.speedMode == measurements.kph){ self.speedometer.bottomText = "km/h"}
        if(self.runController.speedMode == measurements.mph) { self.speedometer.bottomText = "miles/h" }
    }
    
    func distanceUpdated(distance: String) {
        self.distanceView.topText = distance
    }
    

    func timeUpdated(time: String) {
        self.timer.text = "\(time)"
    }
    
    func statusUpdated(status: CLAuthorizationStatus) {
        self.checkPermissions();
    }
    
    func stateUpdated(state: runstate) {
        if(runstate.active == state)
        {
            self.startButtonOutlet.userSelected = true;
            self.pauseButtonOutlet.userSelected = false;
        }

        if(runstate.paused == state)
        {
            self.startButtonOutlet.userSelected = true;
            self.pauseButtonOutlet.userSelected = true;
        }

        if(runstate.stopped == state)
        {
            self.startButtonOutlet.userSelected = false;
            self.pauseButtonOutlet.userSelected = false;
        }
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.checkPermissions()
        
     UIView .animateKeyframesWithDuration(2, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: { () -> Void in
             UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: { () -> Void in
                    self.distanceView.alpha = 1
             })
        UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: { () -> Void in
            self.timer.alpha = 1
        })
        UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: { () -> Void in
            self.speedometer.alpha = 1
        })
        
     }) { (Bool) -> Void in
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.runController.addRunObserver(self)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"pattern")!)
        //set default values
        self.speedometer.topText = "0.0"
        self.speedometer.bottomText = "km/h"
        self.timer.text = "00:00:00"
        self.distanceView.topText = "0.0"
        self.distanceView.bottomText = "km"
        
        self.speedometer.alpha = 0
        self.timer.alpha = 0
        self.distanceView.alpha = 0
        
        self.startRun(self)

    }
    
    

    
    func checkPermissions(){
        var status:CLAuthorizationStatus =  runController.locationStatus
        //switch case that detrmines the error

        if(status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            //display warning
            println("now it's authorized");

        }
        else{
            println("Application is not authorized")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/** Run */
    
    @IBAction func startRun(sender: AnyObject) {
        self.runController.start()
    }
    
    @IBAction func pauseRun(sender: AnyObject) {
        self.runController.pause()
        
    }
    
    
    @IBAction func stopRun(sender: AnyObject) {
        self.runController.stop()
    }

    
    @IBAction func metricMode(sender: AnyObject) {
        self.runController.changeMeasurements()
        //change the measurements

        speedUpdated("\(self.runController.calculateSpeed(self.runController.speed))")
        distanceUpdated("\(self.runController.getDistance(self.runController.distance))")
        
        
           if(self.runController.speedMode == measurements.kph){
                self.distanceView.bottomText = "km"
                self.speedometer.bottomText = "km/h"
                self.speedStateButton.text = "kph"
            }
            else{
                self.distanceView.bottomText = "miles"
                self.speedometer.bottomText = "mph"
                self.speedStateButton.text = "mph"
        }
    }
    
}

