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
    
    //Are we getting any data from our API?
    func testAPIGenerically(){
        let promise = expectation(description: "network fetch succeeded")
        
        let session = URLSession(configuration: .default)
        let url = URL.init(string: "https://mikeleveton.com/MapStackLocations.json")
        let dataTask:URLSessionDataTask = session.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            if error != nil{
                XCTFail("error: \(String(describing: error))")
            }
            if data != nil{
                promise.fulfill()
            }else{
                XCTFail("no data")
            }
        })
        
        dataTask.resume()
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
