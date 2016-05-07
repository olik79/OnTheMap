//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Oliver Körber on 06/05/16.
//  Copyright © 2016 Oliver Körber. All rights reserved.
//

import Foundation

extension UdacityClient {
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let Session = "/session"
    }
    
    struct ParameterKeys {
        static let Udacity = "udacity"
        static let UdacityEmail = "username"
        static let UdacityPassword = "password"
    }
    
    struct ResponseKeys {
        static let CurrentTime = "current_time"
        static let Account = "account"
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        static let CurrentSecondsSinceEpoch = "current_seconds_since_epoch"
        
        // error related
        static let Error = "error"
    }
}