//
//  MapAndTableTabBarController.swift
//  OnTheMap
//
//  Created by Oliver Körber on 08/05/16.
//  Copyright © 2016 Oliver Körber. All rights reserved.
//

import UIKit
import Foundation

class MapAndTableTabBarController: UITabBarController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        // fetch data from parse
        
    }
}
