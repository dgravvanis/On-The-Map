//
//  UdacityClient.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 7/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation

// Udacity API client
class UdacityClient: NSObject {
    
    // MARK: Variables
    var session: NSURLSession
    
    // MARK: Initializer
    override init() {
        
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: Methods
    // Create a session
    func postSession(username: String, password: String, completionHandler: (success: Bool, error: String?) -> Void) {
        
        // Build the url
        let urlString = Constants.baseUrlSecure + UdacityClient.Methods.session
        
        if let url = NSURL(string: urlString) {
            
            let request = NSMutableURLRequest(URL: url)
        
            // Configure the request
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
            let task = session.dataTaskWithRequest(request) { data, response, error in
            
                // Check for download error
                if error != nil {
                
                    completionHandler(success: false, error: Errors.network)
                
                }else{
                    
                    ClientHelper.parseJSONWithCompletionHandler(data, subset: true) { parsedJSON, parsingError in
                        
                        // Check for parsing error
                        if parsingError != nil {
                            
                            completionHandler(success: false, error: Errors.loginFail)
                        
                        // Check if the server response has an error key
                        } else if let error = parsedJSON.valueForKey(JSONResponceKeys.error) as? String {
                            
                            completionHandler(success: false, error: Errors.invalidCredentials)
                            
                        // Check if the server response has an account key
                        } else if let account = parsedJSON.valueForKey(JSONResponceKeys.account) as? [String:AnyObject] {
                            
                            if let key = account[JSONResponceKeys.key] as? String {
                                // Get userID
                                Values.userID = key
                                completionHandler(success: true, error: nil)
                            }
                        }
                    }
                }
            }
            
            // Start the request
            task.resume()
        }
    }
    
    // Delete session
    func deleteSession(completionHandler: (success: Bool, error: String?) -> Void) {
        
        // Build the url
        let urlString = Constants.baseUrlSecure + Methods.session
        
        if let url = NSURL(string: urlString) {
            
            let request = NSMutableURLRequest(URL: url)
            
            // Configure the request
            request.HTTPMethod = "DELETE"
            
            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            
            // Search for Udacity cookie
            for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
                
                if cookie.name == Constants.cookieName {
                    xsrfCookie = cookie
                }
            }
            
            if let xsrfCookie = xsrfCookie {
                request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
            }
            
            let task = session.dataTaskWithRequest(request) { data, response, error in
                
                if error != nil {
                    
                    completionHandler(success: false, error: Errors.network)
                }else{
                    
                    ClientHelper.parseJSONWithCompletionHandler(data, subset: true) { parsedJSON, parsingError in
                        
                        // Check for parsing error
                        if parsingError != nil {
                            
                            completionHandler(success: false, error: Errors.logoutFail)
                            
                        // Check if the server response has an error key
                        } else if let error = parsedJSON.valueForKey(JSONResponceKeys.error) as? String {
                            
                            completionHandler(success: false, error: Errors.logoutFail)
                        
                        // Check if the server response has a session key
                        } else if let session = parsedJSON.valueForKey(JSONResponceKeys.session) as? [String: AnyObject] {
                            
                            println(session)
                            completionHandler(success: true, error: nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // Get user first and last name
    func getUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        
        if let id = Values.userID {
            if let method = ClientHelper.substituteKeyInMethod(Methods.getPublicUserData, key: URLKeys.UserID, value: id) {
                
                // Build the url
                let urlString = Constants.baseUrlSecure + method
                
                if let url = NSURL(string: urlString) {
                    
                    let request = NSMutableURLRequest(URL: url)
                    
                    let task = session.dataTaskWithRequest(request) { data, response, error in
                        
                        if error != nil {
                            
                            println("getUserData, Error: \(error)")
                            completionHandler(success: false, errorString: Errors.network)
                        }
                        
                        // Parse JSON
                        ClientHelper.parseJSONWithCompletionHandler(data, subset: true) {parsedJSON, parsingError in
                            
                            // Check for parsing error
                            if parsingError != nil {
                                
                                println("getUserData, Error: \(parsingError)")
                                completionHandler(success: false, errorString: Errors.loginFail)
                                
                            // Check if the server response has user key
                            }else if let results = parsedJSON.valueForKey(JSONResponceKeys.user) as? [String:AnyObject] {
                                
                                // Check if the server response has first name and last name key
                                if let first = results[JSONResponceKeys.firstName] as? String {
                                    
                                    Values.firstName = first
                                    
                                    if let last = results[JSONResponceKeys.lastName] as? String{
                                        
                                        Values.lastName = last
                                        completionHandler(success: true, errorString: nil)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Start the request
                    task.resume()
                }
            }
        }
    }
    
    // MARK: Helpers
    // Authenticate using username and password
    func authenticateWithCredentials(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Chain completion handlers for each request so that they run one after the other
        self.postSession(username, password: password) { success, errorString in
            
            if success {
                
                self.getUserData() { success, errorString in
                    
                    if success {
                        completionHandler(success: success, errorString: errorString)
                    }else{
                        completionHandler(success: success, errorString: errorString)
                    }
                }
                
            }else{
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    // Shared instance
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}