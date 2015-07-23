//
//  InformationPostingView.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 25/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

// View for posting student information
class InformationPostingView: UIViewController,UITextViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var toobarButtonCancel: UIBarButtonItem!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var topTextContainerView: UIView!
    @IBOutlet weak var topText: UITextView!
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var findLocationOnMapButton: UIButton!
    @IBOutlet weak var submitInfoButton: UIButton!
    
    // MARK: Colours
    let lightGray = UIColor(red: 0.750, green:0.750, blue:0.750, alpha: 1.0)
    let blue = UIColor(red: 0.200, green:0.400, blue:0.600, alpha: 1.0)
    let semiTransparent = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    
    // MARK: Variables
    var mapString: String?
    var latitude: Double?
    var longitude: Double?
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        
        topText.delegate = self
        userText.delegate = self
        initialState()
    }
    
    // MARK: Actions
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Find location from user string
    @IBAction func findLocationOnMap(sender: UIButton) {
        
        // Start activity indicator
        activityIndicatorView.startAnimating()
        
        // Get user input
        mapString = userText.text
        
        var geocoder = CLGeocoder()
        
        // Forward geocode the user text
        geocoder.geocodeAddressString(userText.text) { placemarks, error in
            
            if let error = error {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.presentErrorAlertView(error.description)
                    self.activityIndicatorView.stopAnimating()
                }
            }
            
            else if let placemark = placemarks[0] as? CLPlacemark {
                
                // Configure buttons
                self.findLocationOnMapButton.hidden = true
                self.submitInfoButton.hidden = false
                
                // Stop activity indicator
                self.activityIndicatorView.stopAnimating()
                
                // Configure top toolbar
                self.toobarButtonCancel.tintColor = UIColor.whiteColor()
                self.topToolbar.barTintColor = self.blue
                
                // Configure top text
                self.topTextContainerView.backgroundColor = self.blue
                self.topText.editable = true
                self.topText.textColor = self.lightGray
                self.topText.text = "http://udacity.com"
                
                self.bottomContainerView.backgroundColor = self.semiTransparent
                
                // Show map
                self.mapView.hidden = false
                
                // Get coordinates
                let coordinates = placemark.location.coordinate
                
                // Set the variables values
                self.latitude = placemark.location.coordinate.latitude
                self.longitude = placemark.location.coordinate.longitude
                
                // Create annotation
                var point = MKPointAnnotation()
                point.coordinate = coordinates
                
                // Add annotation and center map
                self.mapView.addAnnotation(point)
                self.mapView.centerCoordinate = coordinates
            }
        }
    }
    
    @IBAction func submitInfo(sender: UIButton) {
        
        if topText.text == "" {
            
            topText.text = "Please enter a link, here."
        }else{
            
            let mediaURL = topText.text
            ParseClient().postStudentLocation(mapString!, latitude: latitude!, longitude: longitude!, mediaURL: mediaURL!) { success, errorString in
                
                if success {
                    
                    dispatch_async(dispatch_get_main_queue()) { self.dismissViewControllerAnimated(true, completion: nil) }
                }else{
                    
                    if let errorString = errorString {
                        
                        // Present error
                        dispatch_async(dispatch_get_main_queue()) { self.presentErrorAlertView(errorString) }
                    }
                }
            }
        }
    }
    
    // MARK: Text view delegate methods
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = ""
        textView.textColor = UIColor.whiteColor()
        textView.font = UIFont(name: "Roboto-Regular", size: 30)
    }
    
    // MARK: Helpers
    // Present alert messages to the user
    func presentErrorAlertView(error: String) {
        
        
        let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func initialState() {
        
        // Configure activity indicator
        activityIndicatorView.hidesWhenStopped = true
        
        // Configure map view
        mapView.hidden = true
        
        // Configure top toolbar
        toobarButtonCancel.tintColor = blue
        topToolbar.barTintColor = lightGray
        topToolbar.translucent = false
        
        // Configure bottom container view
        bottomContainerView.backgroundColor = lightGray
        
        
        // Configure buttons
        findLocationOnMapButton.hidden = false
        findLocationOnMapButton.setTitleColor(blue, forState: UIControlState.Normal)
        findLocationOnMapButton.backgroundColor = UIColor.whiteColor()
        findLocationOnMapButton.layer.cornerRadius = 5.0
        findLocationOnMapButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        submitInfoButton.hidden = true
        submitInfoButton.setTitleColor(blue, forState: UIControlState.Normal)
        submitInfoButton.backgroundColor = UIColor.whiteColor()
        submitInfoButton.layer.cornerRadius = 5.0
        submitInfoButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        // Create a string that will be our sentence
        let sentence = NSMutableAttributedString()
        
        // Create locally formatted strings
        let thin = UIFont(name: "Roboto-Thin", size: 30) ?? UIFont.systemFontOfSize(30.0)
        let thinFont = [NSFontAttributeName:thin]
        
        let regular = UIFont(name: "Roboto-Regular", size: 30) ?? UIFont.systemFontOfSize(30.0)
        let regularFont = [NSFontAttributeName:regular]
        
        let attrString1 = NSAttributedString(string: "Where are you\n", attributes:thinFont)
        let attrString2 = NSAttributedString(string: "studying\n", attributes:regularFont)
        let attrString3 = NSAttributedString(string: "today?", attributes:thinFont)
        
        // Add locally formatted strings to sentence
        sentence.appendAttributedString(attrString1)
        sentence.appendAttributedString(attrString2)
        sentence.appendAttributedString(attrString3)
        
        // Configure top text
        topText.attributedText = sentence
        topTextContainerView.backgroundColor = lightGray
        topText.backgroundColor = UIColor.clearColor()
        topText.editable = false
        topText.textAlignment = NSTextAlignment.Center
        topText.textColor = blue
        
        
        // Configure user text
        userText.backgroundColor = blue
        userText.editable = true
        userText.textAlignment = NSTextAlignment.Center
        userText.textColor = lightGray
        userText.font = UIFont(name: "Roboto-Thin", size: 25)
        userText.text = "e.g. Athens, Greece"
    }
}