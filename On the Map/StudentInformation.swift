//
//  StudentInformation.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 17/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation
import MapKit


// Model for student location
class StudentInformation: NSObject, MKAnnotation {
    
    let title: String
    let mediaUrl: String
    let coordinate: CLLocationCoordinate2D
    
    // Initializer
    init(title: String, url: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.mediaUrl = url
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String {
        
        return mediaUrl
    }
    
    // MARK: Helpers
    // Return Student Information object from dictionary
    class func fromDictionary(dictionary: [String: AnyObject]) -> StudentInformation? {
        
        var title: String!
        var coordinate: CLLocationCoordinate2D!
        var mediaUrl: String!
        
        // Title
        if let first = dictionary[ParseClient.JSONResponseKeys.firstName] as? String {
            if let last = dictionary[ParseClient.JSONResponseKeys.lastName] as? String{
                
                title = "\(first) \(last)"
                
            }else{ title = first }
        }else{ title = nil }
        
        // Location coordinates
        if let latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Double {
            if let longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Double {
                
                coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
            }else{ coordinate = nil }
        }else{ coordinate = nil }
        
        
        
        // URL
        if let url = dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String {
            
            mediaUrl = url
            
        }else{ mediaUrl = nil }
        
        // Return location object
        if title != nil && coordinate != nil && mediaUrl != nil {
            
            return StudentInformation(title: title, url: mediaUrl, coordinate: coordinate)
            
        }else{ return nil }
    }
}