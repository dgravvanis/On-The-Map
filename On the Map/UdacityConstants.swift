//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 7/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Values {
    
        static var userID: String?
        static var firstName: String?
        static var lastName: String?
    }
    
    struct Constants {
    
        static let baseUrlSecure: String = "https://www.udacity.com/api/"
        static let signUpUrl: String = "https://www.google.com/url?q=https%3A%2F%2Fwww.udacity.com%2Faccount%2Fauth%23!%2Fsignin&sa=D&sntz=1&usg=AFQjCNERmggdSkRb9MFkqAW_5FgChiCxAQ"
        static let cookieName = "XSRF-TOKEN"
    }
    
    struct Methods {
    
        static let session = "session"
        static let getPublicUserData = "users/{id}"
    }
    
    struct URLKeys {
        
        static let UserID = "id"
    }
    
    struct JSONBodyKeys {
        
        static let username = "username"
        static let password = "password"
    }
    
    struct JSONResponceKeys {
    
        static let user = "user"
        static let account = "account"
        static let session = "session"
        static let key = "key"
        static let lastName = "last_name"
        static let firstName = "first_name"
        static let error = "error"
    }
    
    struct Errors {
        
        static let network = "Network connection lost"
        static let loginFail = "Login Failed"
        static let invalidCredentials = "Invalid Credentials"
        static let logoutFail = "Logout Failed"
    }
}