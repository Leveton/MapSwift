//
//  Honda.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/31/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import Foundation

enum modelType{
    case kModelTypeCivic
    case kModelTypeAccord
    case kModelTypePrelude
}

class honda: Car{
    
    var model:modelType = .kModelTypeCivic
    
    var model2:modelType = .kModelTypeCivic{
        
        willSet(newModel){
            if (newModel == .kModelTypeCivic){
                self.numberOfDoors = 2
            }else{
                self.numberOfDoors = 4
            }
        }
    }
    
}
