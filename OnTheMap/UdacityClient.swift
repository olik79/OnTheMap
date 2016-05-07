//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Oliver Körber on 06/05/16.
//  Copyright © 2016 Oliver Körber. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient: NSObject {
    var sessionID: String?
    var userKey: String?
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var instance = UdacityClient()
        }
        
        return Singleton.instance
    }
}