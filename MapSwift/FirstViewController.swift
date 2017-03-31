//
//  FirstViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/29/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let car = Car()
        
        let temp = car.numberOfDoors
        print("number of doors \(temp)")
        
        car.numberOfDoors = 3
        car.numberOfWindows = 5
        
        print("number of doors \(car.numberOfDoors) number of windows \(car.numberOfWindows)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

