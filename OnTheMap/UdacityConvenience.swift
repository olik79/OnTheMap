//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Oliver Körber on 06/05/16.
//  Copyright © 2016 Oliver Körber. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    func authenticateWithLoginViewController(loginViewController: LoginViewController,
                                             completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        let userMail = loginViewController.emailTextField.text!
        let userPass = loginViewController.passwordTextField.text!
        
        getUserKeyAndSessionIDWithAccountData(userMail, password: userPass) { (success, userKey, sessionID, errorString) in
            if success {
                self.sessionID = sessionID
                self.userKey = userKey
                
                completionHandlerForAuth(success: true, errorString: nil)
            } else {
                completionHandlerForAuth(success: false, errorString: errorString)
            }
        }
        
        print("mail: \(userMail)")
        print("pass: \(userPass)")
    }
    
    private func getUserKeyAndSessionIDWithAccountData(email: String, password: String,
                                                       loginCompletionListener:(success: Bool, userKey: String?, sessionID: String?, errorString: String?) -> Void) {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Constants.ApiScheme
        urlComponents.host = Constants.ApiHost
        urlComponents.path = Constants.ApiPath + Methods.Session
        
        let url = urlComponents.URL!
        print(url)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData = [ ParameterKeys.Udacity : [
            ParameterKeys.UdacityEmail : email,
            ParameterKeys.UdacityPassword : password
            ]
        ]
        
        var jsonBody: NSData?
        do {
           jsonBody = try NSJSONSerialization.dataWithJSONObject(postData, options: .PrettyPrinted)
        } catch {
            loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "Could not create json body")
        }
        
        print("HTTP body: \(NSString(data: jsonBody!, encoding: NSUTF8StringEncoding))")
        
        
        request.HTTPBody = jsonBody
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "Server didn't return any data")
                return
            }
            
            var parsedResult: AnyObject!
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "Received data couldn't be parsed as JSON")
            }
            
            guard let jsonData = parsedResult as? [String : AnyObject] else {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "Received data didn't contain entries")
                return
            }
            
            guard let urlHttpResponse = response as? NSHTTPURLResponse else {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "Received invalid response from server")
                return
            }
            
            // udacity will return error information within ResponseKey "error", so we can access that key to show the user some detailed message
            guard urlHttpResponse.statusCode >= 200 && urlHttpResponse.statusCode < 300 else {
                let errorMessageFromServer = jsonData[ResponseKeys.Error] as? String
                var errorString = "Server returned invalid HTTP status code (\(urlHttpResponse.statusCode))."
                if let errorMessageFromServer = errorMessageFromServer {
                    errorString = "\(errorString) \n\nError message from Server: \n\n\(errorMessageFromServer)"
                }
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: errorString)
                return
            }
            
            guard let accountEntry = jsonData[ResponseKeys.Account] as? [String:AnyObject], let sessionEntry = jsonData[ResponseKeys.Session] as? [String:AnyObject] else {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "Received data didn't contain needed entries")
                return
            }
            
            guard let sessionID = sessionEntry[ResponseKeys.SessionID] as? String else {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "SessionID is no String")
                return
            }
            
            guard let userKey = accountEntry[ResponseKeys.AccountKey] as? String else {
                loginCompletionListener(success: false, userKey: nil, sessionID: nil, errorString: "Account key is no String")
                return
            }

            loginCompletionListener(success: true, userKey: userKey, sessionID: sessionID, errorString: nil)
        }
        
        dataTask.resume()
    }
}