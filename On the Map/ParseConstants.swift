//
//  ParseConstants.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 18/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Values {
        
        static var studentInfo = [StudentInformation]()
    }
    
    struct Constants {
        
        static let parseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseAppIdHeader = "X-Parse-Application-Id"
        static let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let restApiKeyHeader = "X-Parse-REST-API-Key"
        static let baseUrlSecure = "https://api.parse.com/1/classes/"
    }
    
    struct Methods {
        
        static let studentLocation = "StudentLocation"
    }
    
    struct UrlKeys {
        
        static let limit = "?limit=100"
    }
    
    struct JSONResponseKeys {
        
        static let results = "results"
        static let objectId = "objectId"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let objID = "objectId"
    }
    
    struct Errors {
        
        static let network = "Network connection lost"
        static let getUserPostsFail = "Student's posts update failed"
    }
}