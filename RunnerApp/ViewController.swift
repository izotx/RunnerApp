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
    

    @IBOutlet weak var speedMeasurementsLabel: UILabel!

    @IBOutlet weak var distanceView: DoubleLabel!
    @IBOutlet weak var timer: SingleLabel!
    @IBOutlet weak var speedometer: DoubleLabel!
    
    @IBOutlet weak var speedStateButton: mphButton!

    //Run Protocol
    func speedUpdated(speed: Double) {
        self.speedometer.topText = "\(speed)"
    }
    
    func distanceUpdated(distance: Double) {
        self.distanceView.topText = "\(distance)"
    }
    
    func convertToText(time:Int)->String{
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
    
    func timeUpdated(time: Int) {
        var timeDisplay = convertToText(time)
        self.timer.text = "\(timeDisplay)"
    }
    
    func statusUpdated(status: CLAuthorizationStatus) {
        self.checkPermissions();
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.checkPermissions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.runController.addRunObserver(self)
        // Do any additional setup after loading the view, typically from a ni
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"pattern")!)
        
    }
    
 
    //stop, pause and start new
    func displaySpeed(){
        if self.runController.speed >= 0 {
            self.speedometer.topText = "\(self.runController.speed)"
        }
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
            if(self.runController.speedMode == measurements.kph){
                self.distanceView.bottomText = "km"
                self.speedometer.bottomText = "kph"
                self.speedStateButton.text = "kph"
            }
            else{
                self.distanceView.bottomText = "km"
                self.speedometer.bottomText = "mph"
                self.speedStateButton.text = "mph"
        }
            self.displaySpeed()
    }
    
}

