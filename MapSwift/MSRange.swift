//
//  MSRange.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/27/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

struct MSRange{
    var startPoint:Float = 0.0{
        didSet{
            
        }
    }
    var endPoint:Float = 0.0{
        didSet{
            
        }
    }
    
    static func ==(lhs:MSRange, rhs:MSRange) -> Bool{
        if (lhs.startPoint == rhs.startPoint && lhs.endPoint == rhs.endPoint)
            ||
            (lhs.endPoint == rhs.startPoint && lhs.startPoint == rhs.endPoint){
            return true
        }
        return false
    }
    
}
