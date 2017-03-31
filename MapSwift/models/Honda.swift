//
//  Honda.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/31/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import Foundation

enum modelType{
    case Civic
    case Accord
    case Prelude
}

class Honda: Car{
    
    var model:modelType = .Civic{
        
        willSet(newModel){
            if (newModel == .Civic){
                self.numberOfDoors = 2
            }else{
                self.numberOfDoors = 4
            }
        }
    }
    
}
