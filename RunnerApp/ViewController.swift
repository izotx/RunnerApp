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
class ViewController: UIViewController {
    private var myContext = 0
    private var locationController:LocationController =  LocationController()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.checkPermissions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationController.addObserver(self, forKeyPath: "status", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "speed", options:.New , context: nil)
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            self.checkPermissions()
        }
    }
    
    func checkPermissions(){
        var status:CLAuthorizationStatus =  locationController.status
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


}

