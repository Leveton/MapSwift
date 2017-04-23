//
//  MSFavoritesViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSFavoritesViewController: MSViewController {

    var dataSource = [MSLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //save the user's name for access in other modules
        UserDefaults.standard.set("Mike", forKey: "userName")
        
        //access this in other modules
        print("user name: \(UserDefaults.standard.object(forKey: "userName") as! String)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
