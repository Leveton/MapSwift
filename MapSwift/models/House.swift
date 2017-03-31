//
//  House.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/31/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

class House{
    
    var numberOfWindows:Int = 0
    
    /* the House class has a property with the exact same name as the Car class */
    var numberOfDoors:Int = 0 {
        willSet{
            self.numberOfWindows = newValue
        }
    }
}
