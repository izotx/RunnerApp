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
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var speedMeasurementsLabel: UILabel!

    
//Run Protocol
    func speedUpdated(speed: Double) {
         self.speed.text = "\(speed)"
    }
    
    func distanceUpdated(distance: Double) {
        self.distance.text = "\(distance)"
    }
    
    func timeUpdated(time: Int) {
        self.duration.text = "\time"
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
        // Do any additional setup after loading the view, typically from a nib.
     }
    
 
    //stop, pause and start new
    func displaySpeed(){
        if self.runController.speed >= 0 {
            self.speed.text = "\(self.runController.speed)"
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
                self.speedMeasurementsLabel.text = "kph"
            }
            else{
                self.speedMeasurementsLabel.text = "mph"
            }
            self.displaySpeed()
    }
    
}

