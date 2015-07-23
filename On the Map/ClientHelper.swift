//
//  ClientHelper.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 13/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation

// Class that has common helper methods used by the API Clients
class ClientHelper {
    
    // Substitute the key for the value that is contained within the method name
    class func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        
        if method.rangeOfString("{\(key)}") != nil {
            
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
            
        } else {
            
            return nil
        }
    }
    
    // Given raw JSON, return a usable Foundation object.
    class func parseJSONWithCompletionHandler(rawData: NSData, subset: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var data = rawData
        
        if subset {
            
            // Subset data, required by the Udacity API
            data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        }
        
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
}