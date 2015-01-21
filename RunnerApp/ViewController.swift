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
        
    }
    
    func distanceUpdated(distance: Double) {
        
    }
    
    func timeUpdated(time: Int) {
        
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
    
    //change the measurements
    func changeMeasurements(){
        if(self.runController.speedMode == measurements.kph){
            runController.changeMeasurements(measurements.mph)
            self.speedMeasurementsLabel.text = "mph"
        }
        else{
            runController.changeMeasurements(measurements.kph)
            self.speedMeasurementsLabel.text = "kph"
        }
        self.displaySpeed()
    }

    //stop, pause and start new
    func displaySpeed(){
        if self.runController.speed >= 0 {
            self.speed.text = "\(self.runController.speed)"
        }
    }
    
 
    
    func checkPermissions(){
        var status:CLAuthorizationStatus =  runController.status
        //switch case that detrmines the error
        if(status == CLAuthorizationStatus.Authorized || status == CLAuthorizationStatus.AuthorizedWhenInUse)
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


    @IBAction func startRun(sender: AnyObject) {
        self.runController.start()
    }
}

