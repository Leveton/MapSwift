//
//  FavoritesTests.swift
//  MapSwiftTests
//
//  Created by Michael Leveton on 4/7/18.
//  Copyright © 2018 mikeleveton. All rights reserved.
//

import XCTest
import MapKit
@testable import MapSwift

class FavoritesTests: XCTestCase {
    
    var favsVC:MSFavoritesViewController?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //TODO: write these tests!
    func testFavsReorder(){
    
    }
    
    private func description(with arr:Array<MSLocation>){
        for loc in arr{
            print("type \(loc.type!)")
        }
    }
    
    private func randomLocation() -> MSLocation{
        var coord = CLLocationCoordinate2D()
        coord.latitude = 0.0
        coord.longitude = 0.0
        let dist = 0.0 as CGFloat
        let types = ["Hospital", "School", "StartUp","Random","Restaurant"]
        let random = Int(arc4random_uniform(5))
        let loc = MSLocation(coordinate: coord, distance: dist)
        loc.type = types[random]
        return loc
    }
}
