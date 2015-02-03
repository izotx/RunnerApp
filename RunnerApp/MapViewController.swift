//
//  MapViewController.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 2/2/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, LocationUpdated, MKMapViewDelegate{
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: mphButton!
    
    var dataController:DataController?
   
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.removeOverlays(self.mapView.overlays)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.text = "Back"
        //get app delegate
        self.dataController?.observer = self
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true

        //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("coreDataUpdated"), name: NSManagedObjectContextDidSaveNotification, object: <#AnyObject?#>)
    }

    func updateRun(run: Run?) {
        
        println("map updated")
        //display the overlay
        if let tempRun:Run = run {
        
           var children =  tempRun.mutableOrderedSetValueForKey("locations")
            println("c ciybt \(children.count)")
            
            var points : [CLLocationCoordinate2D] = []
            for(var i = 0; i<children.count; i++) {
                
                var loc:Location = children.objectAtIndex(i) as Location
                var loc2d =   CLLocationCoordinate2D(latitude: CLLocationDegrees(loc.latitude.floatValue), longitude: CLLocationDegrees(loc.longitude.floatValue))
                points.append(loc2d)
                
            }
            
            var polygon: MKPolyline = MKPolyline(coordinates: &points, count: points.count)

            self.mapView.addOverlay(polygon)
            
            
          //  var cl:CLLocationCoordinate2D =
          // var polyline = MKPolyline(
          
            
            
            
        }
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        return nil
    }
    
}