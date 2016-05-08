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
                    let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in })
                    
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
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
            
            performUIUpdatesOnMain({ 
                self.completeLogin()                
            })
        }
    }
    
    @IBAction func signupButtonClicked(sender: UIButton) {
        let url = NSURL(string: UdacityClient.URLs.Signup)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func completeLogin() {
        let mapAndTableTabBarController =
            storyboard!.instantiateViewControllerWithIdentifier("MapAndTable")
        presentViewController(mapAndTableTabBarController, animated: true, completion: nil)
    }
}

