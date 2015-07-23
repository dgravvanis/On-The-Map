//
//  StudentLocationsTableView.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 21/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation
import UIKit

// Table view with student names and links
class StudentLocationsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
    }
    
    // MARK: Table view delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return studentInfo count
        return ParseClient.Values.studentInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Dequeue the reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("studentInfoCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Get student info
        let info = ParseClient.Values.studentInfo[indexPath.row]
        
        // Populate and return cell
        cell.imageView?.image = UIImage(named: "PinIcon")
        cell.detailTextLabel?.text = info.subtitle
        cell.textLabel?.text = info.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Get url
        let urlString = ParseClient.Values.studentInfo[indexPath.row].subtitle
        
        // Check if an app can open the given URL and open url
        if let url = NSURL(string: urlString) {
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                
                UIApplication.sharedApplication().openURL(url)
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
    @IBAction func refreshStudentInfo(sender: UIBarButtonItem) {
        
        // Get student locations
        ParseClient.sharedInstance().getStudentLocations() { success, errorString, result in
            
            if success {
                
                // Refresh table
                dispatch_async(dispatch_get_main_queue()) { self.tableView.reloadData() }
            }else{
                
                if let errorString = errorString {
                    
                    // Present error
                    dispatch_async(dispatch_get_main_queue()) { self.presentErrorAlertView(errorString) }
                }
            }
        }
    }
    
    @IBAction func launchInfoPostingView(sender: UIBarButtonItem) {
     
        // Grab the controller from storyboard
        var controller = storyboard?.instantiateViewControllerWithIdentifier("infoPostingView") as! InformationPostingView
        
        // Present controller
        presentViewController(controller, animated: true, completion: nil)
    }
}