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
        let coder = NSCoder()
        favsVC = MSFavoritesViewController(coder: coder)
        favsVC?.tableView = UITableView()
        var dataSource = [MSLocation]()
        
        //datasource of locations with randomly selected types
        for _ in 0...10{
            dataSource.append(randomLocation())
        }
        favsVC?.dataSource = dataSource
    }
    
    override func tearDown() {
        favsVC = nil
        super.tearDown()
    }
    
    func testFavsReorder(){
        //put in in alphabetical order to easily test. Our random location method will pick types randomly.
        let typesArray = ["Hospital", "School", "StartUp", "Random", "Restaurant"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GlobalStrings.FavoritesRearranged.rawValue), object: typesArray)
        let sorted = favsVC?.dataSource.sorted{ $0.type! < $1.type! }
        description(with: (favsVC?.dataSource)!)
        description(with: sorted!)
        XCTAssertEqual(favsVC?.dataSource, sorted)
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
