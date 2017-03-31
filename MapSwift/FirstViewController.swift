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
        
        configureCar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK: selectors
    
    func configureCar(){
        let car = Car()
        
        let temp = car.numberOfDoors
        print("number of doors \(temp)")
        
        car.numberOfDoors = 3
        car.numberOfWindows = 5
        car.color = "Red"
        
        print("number of doors again \(car.numberOfDoors) number of windows \(car.numberOfWindows)")
        
        let honda = Honda()
        honda.model = .Accord
        print("number of doors honda \(honda.numberOfDoors)")
        
        car.startEngine()
        
        let house = House()
        house.numberOfDoors = 1
        print("number of house doors \(house.numberOfDoors) number of house windows \(house.numberOfWindows)")
        
    }

}

