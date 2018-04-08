//
//  MapViewTests.swift
//  MapSwiftTests
//
//  Created by Michael Leveton on 4/7/18.
//  Copyright © 2018 mikeleveton. All rights reserved.
//

import XCTest
import MapKit
@testable import MapSwift

class MapViewTests: XCTestCase {
    let coordinateDistance:CGFloat = 157.61929069755391
    var location:MSLocation?
    var coordinate:CLLocationCoordinate2D?
    
    override func setUp() {
        super.setUp()
        
        coordinate = CLLocationCoordinate2D()
        coordinate?.latitude  = -70.0
        coordinate?.longitude = 45.0
        
        var dict:Dictionary = [AnyHashable:Any]()
        dict["distance"]  = 50.3 as CGFloat
        dict["latitude"]  = 25.78
        dict["longitude"] = -80.18
        location = MSLocation.serializeLocationWith(dict: dict)
    }
    
    override func tearDown() {
        location = nil
        super.tearDown()
    }
    
    //test both correct serialization and the getDistance function. It's ok to unwrap here because if coordinate or loc.coordinate are nil, then something's wrong with our tests.
    func testSerializationAndDistance(){
        XCTAssertEqual(Double(coordinateDistance), location?.getDistanceFromPoint(pointA: coordinate!, pointB: (location?.coordinate)!))
    }
}
