//
//  RunController.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit
import CoreData

class RunController: NSObject {
    var currentRunIndex: Int
    
    enum runstate{
        case active
        case stopped
        case paused
    }
    
    override init() {
        self.currentRunIndex = -1
        super.init()
    }
    
    func start(){
        //create new run
    }
    
    func finish(){
        //stop running
    }
    
    func pause(){
        //pause running
    }
    
    func resume(){

    }
    
    func createNewRun(){
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
   
 }
    
    
}


