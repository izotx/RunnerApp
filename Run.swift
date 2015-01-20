//
//  Run.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import CoreData

class Run: NSManagedObject {

    @NSManaged var averagespeed: NSNumber
    @NSManaged var started: NSDate
    @NSManaged var distance: NSNumber
    @NSManaged var finished: NSDate
    @NSManaged var locations: NSOrderedSet

}
