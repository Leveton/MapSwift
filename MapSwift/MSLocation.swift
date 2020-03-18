//
//  File.swift
//  MapSwift
//
//  Created by Michael Leveton on 3/17/20.
//  Copyright © 2020 mikeleveton. All rights reserved.
//


class MSLocation {
    
    // can be nil
    private var title: String!
    
    // cannot be nil
    var xCoordintate: Double
    var yCoordinate: Double
    
    init(x: Double, y: Double){
        self.xCoordintate = x
        self.yCoordinate = y
    }
    
    func getTitle() -> String {
        return title
    }
}
