//
//  ParseClient.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 17/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation

// Parse API client
class ParseClient: NSObject {
    
    // MARK: Variables
    var session: NSURLSession
    
    // Student information array
    //var studentInfo = [StudentInformation]()
    
    //MARK: Initializer
    // Initializer
    override init() {
        
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: Methods
    // Return array with student's locations as Location objects
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?, result: [StudentInformation]?) -> Void) {
        
        // Clear the array from previous entries
        Values.studentInfo.removeAll()
        
        // Build the url
        let urlString = Constants.baseUrlSecure + Methods.studentLocation + UrlKeys.limit
        
        if let url = NSURL(string: urlString) {
            
            let request = NSMutableURLRequest(URL: url)
            
            // Configure the request
            request.addValue(Constants.parseAppId, forHTTPHeaderField: Constants.parseAppIdHeader)
            request.addValue(Constants.restApiKey, forHTTPHeaderField: Constants.restApiKeyHeader)
            
            // Make the request
            let task = session.dataTaskWithRequest(request) { data, response, downloadError in
                
                // Check for download error
                if let error = downloadError {
                    
                    completionHandler(success: false, errorString: Errors.network, result: nil)
                    
                }else{
                    
                    // Parse JSON
                    ClientHelper.parseJSONWithCompletionHandler(data, subset: false) { parsedJSON, parsingError in
                        
                        // Check for parsing error
                        if let error = parsingError {
                            
                            completionHandler(success: false, errorString: Errors.getUserPostsFail, result: nil)
                        
                        // Check if the server response has results key
                        }else if let results = parsedJSON.valueForKey(JSONResponseKeys.results) as? [[String:AnyObject]] {
                            
                            for item in results {
                                
                                if let info = StudentInformation.fromDictionary(item){
                                    
                                    Values.studentInfo.append(info)
                                }
                            }
                            completionHandler(success: true, errorString: nil, result: Values.studentInfo)
                        }
                    }
                }
            }
            
            // Start the request
            task.resume()
        }
    }
    
    func postStudentLocation(mapString: String, latitude: Double, longitude: Double, mediaURL: String,completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Get user first name, last name, userID
        let first = UdacityClient.Values.firstName!
        let last = UdacityClient.Values.lastName!
        let uniqueKey = UdacityClient.Values.userID!
        
        // Build the url
        let urlString = Constants.baseUrlSecure + Methods.studentLocation
        
        if let url = NSURL(string: urlString) {
            
            let request = NSMutableURLRequest(URL: url)
            
            // Configure the request
            request.HTTPMethod = "POST"
            request.addValue(Constants.parseAppId, forHTTPHeaderField: Constants.parseAppIdHeader)
            request.addValue(Constants.restApiKey, forHTTPHeaderField: Constants.restApiKeyHeader)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(first)\", \"lastName\": \"\(last)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = session.dataTaskWithRequest(request) { data, response, error in
                
                if error != nil {
                    
                    completionHandler(success: false, errorString: Errors.network)
                }else{
                    
                    ClientHelper.parseJSONWithCompletionHandler(data, subset: false) { parsedJSON, error in
                       
                        if let postID = parsedJSON.valueForKey(JSONResponseKeys.objID) as? String {
                            
                            completionHandler(success: true, errorString: nil)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    // MARK: Helper
    // Shared instance
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}