//
//  Boat.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/31/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class Boat: NSObject {

    var numberOfDoors:Int = 0
    var color:String = "White"
    
    var engine:Engine?
    
    var bulbousBow = CGPoint()
    var hullSize = CGSize()
    var flagPosition = CGRect()
}

struct Engine {
    let cylinder:Int
    
    init(cylinder:Int) {
        self.cylinder = cylinder
    }
}
