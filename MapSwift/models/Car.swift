//
//  Car.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/31/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import Foundation
import UIKit

class Car: NSObject{
    
    /* number of doors is an encapsulated property of the Car class */
    var numberOfWindows:Int = 0
    
    var numberOfDoors:Int {
        get{
            return self.numberOfWindows
        }
        set{
            self.numberOfWindows = newValue
        }
    }
    
    
}
