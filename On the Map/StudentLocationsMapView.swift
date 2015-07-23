//
//  StudentLocationsMapView.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 11/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import MapKit

// Map view with student locations
class StudentLocationsMapView: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        
        mapView.delegate = self
        loadInitialData()
    }
    
    // MARK: Map View Delegate Methods
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let annotation = annotation as? StudentInformation {
            
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    // Open Safari with the url provided from the annotation
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        // Get url
        let urlString = view.annotation.subtitle
        
        // Check if an app can open the given URL and open url
        if let url = NSURL(string: urlString!) {
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: Methods
    // Load initial data
    func loadInitialData() {
        
        // Get student locations
        ParseClient.sharedInstance().getStudentLocations() { success, errorString, result in
            
            if success {
                
                // Add locations to map
                dispatch_async(dispatch_get_main_queue()) { self.mapView.addAnnotations(result) }
            }else{
                
                if let errorString = errorString {
                    
                    // Present error
                    dispatch_async(dispatch_get_main_queue()) { self.presentErrorAlertView(errorString) }
                }
            }
        }
    }
    
    // MARK: Helpers
    // Present alert messages to the user
    func presentErrorAlertView(error: String) {
    
        
        let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    // Logout user and present login screen
    @IBAction func logOut(sender: UIBarButtonItem) {
        
        UdacityClient.sharedInstance().deleteSession() { success, errorString in
            
            if let errorString = errorString {
                
                // Present error
                dispatch_async(dispatch_get_main_queue()) { self.presentErrorAlertView(errorString) }
            }else{
                
                // Dismiss view controller
                dispatch_async(dispatch_get_main_queue()) { self.dismissViewControllerAnimated(true, completion: nil) }
            }
        }
    }
    
    // Refresh the student information
    @IBAction func refreshStudentInfo(sender: UIBarButtonItem) {
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        // Add new annotations
        loadInitialData()
    }
    
    @IBAction func launchInfoPostingView(sender: UIBarButtonItem) {
        
        // Grab the controller from storyboard
        var controller = storyboard?.instantiateViewControllerWithIdentifier("infoPostingView") as! InformationPostingView
        
        // Present controller
        presentViewController(controller, animated: true, completion: nil)
    }
}
