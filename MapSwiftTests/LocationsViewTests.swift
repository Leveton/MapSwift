//
//  LocationsViewTests.swift
//  MapSwiftTests
//
//  Created by Michael Leveton on 4/7/18.
//  Copyright © 2018 mikeleveton. All rights reserved.
//

import XCTest
@testable import MapSwift

class LocationsViewTests: XCTestCase {
    
    var detailVC:MSLocationDetailViewController?
    
    override func setUp() {
        super.setUp()
        detailVC = MSLocationDetailViewController()
        
        var dict:Dictionary = [AnyHashable:Any]()
        dict["distance"]  = 50.3 as CGFloat
        dict["latitude"]  = 25.78
        dict["longitude"] = -80.18
        let location = MSLocation.serializeLocationWith(dict: dict)
        location?.locationID = 1
        detailVC?.location = location
    }
    
    override func tearDown() {
        detailVC = nil
        super.tearDown()
    }

    func testFavsBusinessLogic(){
        let favs = [9,8,6]
        let newFavs = detailVC?.handleFavoriteTapped(with:favs)
        guard let incrementedFavs = newFavs else {
            XCTFail("favs is nil")
            return
        }
        XCTAssert(incrementedFavs.count == 4)
        XCTAssert(incrementedFavs[3] == 1)
        let newerFavs = detailVC?.handleFavoriteTapped(with:favs)
        guard let decrimentedFavs = newerFavs else{
            XCTFail("favs is nil")
            return
            
        }
        XCTAssert(decrimentedFavs.count == 3)
        XCTAssert(decrimentedFavs[0] == 9)
        XCTAssert(decrimentedFavs[2] == 6)
    }
}
