//
//  FirstViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/29/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

struct SomeSize{
    var width  = 0
    var height = 0
}

class FirstViewController: UIViewController {

    var arrayA:Array<String>!
    weak var carA:Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayA = Array()
        
        
//        configureCar()
//        configureHouse()
//        configureBoat()
        compareReferenceAndValue()
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
        
    }
    
    func configureHouse(){
        let house = House()
        
        house.numberOfDoors = 1
        print("number of house doors \(house.numberOfDoors) number of house windows \(house.numberOfWindows)")
        
    }

    func configureBoat(){
        let boat = Boat()
        
        if boat.isKind(of: Boat.self){
            boat.numberOfDoors = 1
            print("number of boat doors \(boat.numberOfDoors)")
        }
        if boat.isKind(of: NSObject.self){ print("is kind of NSObject") } //prints out
        if boat.isMember(of: Boat.self){ print("is member of boat") } //prints out
        if boat.isMember(of: NSObject.self){ print("is member of NSObject") } //does not print out
    }
    
    func compareReferenceAndValue(){
        
        let boat = Boat()
        boat.color = "Red"
        
        /* boat and ship both point to the same chunk of memory */
        let ship = boat
        ship.color = boat.color
        boat.color = "Green"
        
        var someSize = SomeSize()
        someSize.width = 20
        
        /* anotherSize is copied on assignment creating a new chunk of memory */
        var anotherSize = someSize
        anotherSize.width = someSize.width
        someSize.width = 40
        
    }
}

