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
    
    /*let's define some encapsulated constants */
    private let locStringHelloWorld = "Hello World"
    private let labelSide           = CGFloat(200)
    /* end constants */
    
    /* mutable and accessable variables */
    var arrayA:Array<String>!
    weak var carA:Car?
    var carB:Car!
    
    var label:UILabel!{
        didSet{
            
            label.text = locStringHelloWorld
            label.textAlignment = .center
            label.layer.borderColor = self.label.textColor.cgColor
            label.layer.borderWidth = 1.0
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var labelFrame = label.frame
        labelFrame.size.width  = labelSide
        labelFrame.size.height = labelSide
        labelFrame.origin.x = (self.view.frame.width - labelSide)/2
        labelFrame.origin.y = (self.view.frame.height - labelSide)/2
        label.frame = labelFrame
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayA = Array()
        label = UILabel()
        self.view.addSubview(label)
        
        self.view.backgroundColor = UIColor.red
        
        configureCar()
        configureHouse()
        configureBoat()
        compareReferenceAndValue()
        
        /* we can get a value from the house class without having to allocate additional memory */
        let variable = House.SomeComplexOperationUniqueToHouse()
        
        print("double \(variable)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: selectors
    
    func configureCar(){
        
        let car = Car()
        
        carB = car
        
        let temp = car.numberOfDoors
        print("number of doors \(temp)")
        
        car.numberOfDoors = 3
        car.numberOfWindows = 5
        
        print("number of doors again \(car.numberOfDoors) number of windows \(car.numberOfWindows) color\(car.color)")
        
        let honda = Honda()
        honda.model = .Accord
        print("number of doors honda \(honda.numberOfDoors)")
        
        car.startEngine()
        
    }
    
    func configureHouse(){
        let house = House()
        
        house.numberOfDoors = 1
        print("number of house doors \(house.numberOfDoors) number of house windows \(house.numberOfWindows)")
        
        house.frame.origin.x = 20.0
        house.frame.origin.y = house.frame.maxX
        
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
        
        boat.engine = Engine(cylinder: 4)
        print("boat engine \(boat.engine!) cylinder count \(boat.engine!.cylinder)")
        
        //let titanic = Boat()
        //titanic.engine = Engine()
        
        boat.hullSize = CGSize(width: 200, height: 100)
        boat.bulbousBow = CGPoint(x: 200.0, y: 0.0)
        boat.flagPosition = CGRect(origin: boat.bulbousBow, size: boat.hullSize)
        print("hull \(boat.hullSize.width) bow \(boat.bulbousBow.y)")
        print("flag \(boat.flagPosition.origin.x+boat.flagPosition.size.width)")
        
    }
    
    func compareReferenceAndValue(){
        
        let boat = Boat()
        boat.color = "Red"
        
        /* kar and car both point to the same chunk of memory */
        let ship = boat
        ship.color = boat.color
        print("boat color \(boat.color) ship color \(ship.color)")
        
        boat.color = "Green"
        print("boat color \(boat.color) ship color \(ship.color)")
        
        var someSize = SomeSize()
        someSize.width = 20
        
        /* anotherSize is copied on assignment creating a new chunk of memory */
        var anotherSize = someSize
        anotherSize.width = someSize.width
        print("some size width \(someSize.width) another size width \(anotherSize.width)")
        
        someSize.width = 40
        print("some size width again \(someSize.width) another size width again \(anotherSize.width)")
        
    }
}

