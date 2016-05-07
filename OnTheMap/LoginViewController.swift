//
//  ViewController.swift
//  OnTheMap
//
//  Created by Oliver Körber on 05/05/16.
//  Copyright © 2016 Oliver Körber. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonClicked(sender: UIButton) {
        let udacityClient = UdacityClient.sharedInstance()
        
        udacityClient.authenticateWithLoginViewController(self) { (success, errorString) in
            if !success {
                performUIUpdatesOnMain({ 
                    let alertView = UIAlertView.init(title: "Error", message: errorString!, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()                    
                })
                return
            }
            guard let sessionID = UdacityClient.sharedInstance().sessionID else {
                print("sessionID wasn't set!")
                return
            }
            
            guard let userKey = UdacityClient.sharedInstance().userKey else {
                print("userKey wasn't set!")
                return
            }

            print("Received session ID: \(sessionID)")
            print("Received user key: \(userKey)")
        }
    }
    
}

