//
//  MSLocation.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/17/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit
import MapKit

class MSLocation: NSObject, MKAnnotation {

    var title:String?
    var type:String?
    @objc var coordinate:CLLocationCoordinate2D
    var distance:CGFloat?
    var locationImage:UIImage?
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    func getDistanceFromPoint(pointA:CLLocationCoordinate2D, pointB:CLLocationCoordinate2D) -> Double{
        /* if you square a negative number, you get a quiet nan */
        return sqrt(abs(((pointA.latitude - pointB.latitude) * 2) + ((pointA.longitude - pointB.longitude) * 2)))
    }
}