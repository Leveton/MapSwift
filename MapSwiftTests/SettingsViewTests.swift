//
//  SettingsTests.swift
//  MapSwiftTests
//
//  Created by Michael Leveton on 4/7/18.
//  Copyright © 2018 mikeleveton. All rights reserved.
//

import XCTest
@testable import MapSwift

class SettingsTests: XCTestCase {
    var settingsVC:MSSettingsViewController?
    
    override func setUp() {
        super.setUp()
        let coder = NSCoder()
        settingsVC = MSSettingsViewController(coder:coder)
    }
    
    override func tearDown() {
        settingsVC = nil
        super.tearDown()
    }
    
    func testRange(){
        let index = IndexPath(row: 3, section: 0)
        let range = settingsVC?.getRangeFromIndexPath(index: index)
        XCTAssertEqual(range?.startPoint, 3_000.0)
        XCTAssertEqual(range?.endPoint, 10_000.0)
    }
}
