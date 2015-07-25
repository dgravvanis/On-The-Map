//
//  LoginViewController.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 4/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// Login view
class LoginViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var topLabel: UILabel!
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        
        emailTextField.text = ""
        passwordTextField.text = ""
        hideActivity()
    }
    
    // MARK: Actions
    // Login to Udacity
    @IBAction func login(sender: LoginButton) {
        
        if emailTextField.isEmpty() {
            emailTextField.animate()
        }
        if passwordTextField.isEmpty() {
            passwordTextField.animate()
        }
        
        if emailTextField.isEmpty() == false && passwordTextField.isEmpty() == false {
            
            showActivity()
            UdacityClient.sharedInstance().authenticateWithCredentials(emailTextField.text, password: passwordTextField.text) { success, errorString in
                
                if success {
                    
                    self.completeLogin()
                }else{
                    
                    self.displayError(errorString)
                }
            }
        }
    }
    
    // Open Safari and go to Udacity sign up page
    @IBAction func signUp(sender: UIButton) {
        
        // Get url
        let urlString = UdacityClient.Constants.signUpUrl
        
        // Check if an app can open the given URL and open url
        if let url = NSURL(string: urlString) {
            
            if UIApplication.sharedApplication().canOpenURL(url) {
            
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: Helpers
    // Show activity view
    func showActivity() {
            
        var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.tag = 100
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    // Hide activity view
    func hideActivity() {
        
        for subview in self.view.subviews {
            
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }
    
    // Complete login, present tab bar controller
    func completeLogin() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // Display error messages to the user and animate text fields
    func displayError(errorString: String?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.emailTextField.animate()
            self.passwordTextField.animate()
            
            if let errorString = errorString {
                
                self.presentErrorAlertView(errorString)
                self.hideActivity()
            }
        }
    }
    
    // Present alert messages to the user
    func presentErrorAlertView(error: String) {
        
        let alertController = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

