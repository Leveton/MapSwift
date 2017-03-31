//
//  Car.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/31/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

class Car{
    
    /* number of doors is an encapsulated property of the Car class */
    var numberOfWindows:Int = 0
    
    var numberOfDoors:Int = 0
    
    var color:String{
        get{
            return self.color
        }
        set{
            if (newValue == "Red"){
                self.numberOfWindows = 3
            }
        }
    }
    
    /* this is an encapsulated public method of the Car class */
    func startEngine(){
        print("vooom")
    }
    
    /* this is an encapsulated private method of the Car class */
    private func stopEngine(){
        print("errrt")
    }
}
