//
//  MSLocation.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/17/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit
import MapKit

class MSLocation: NSObject, MKAnnotation, NSCopying {

    var title:String?
    var type:String?
    var subtitle: String?
    @objc var coordinate:CLLocationCoordinate2D
    var distance:CGFloat?
    var locationImage:UIImage?
    var locationID:Int?
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    func getDistanceFromPoint(pointA:CLLocationCoordinate2D, pointB:CLLocationCoordinate2D) -> Double{
        /* if you square a negative number, you get a quiet nan */
        return sqrt(abs(((pointA.latitude - pointB.latitude) * 2) + ((pointA.longitude - pointB.longitude) * 2)))
    }
    
    func copy(with zone: NSZone? = nil) -> Any{
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude  = 0
        coordinate.longitude = 0
        let location = MSLocation(coordinate: coordinate)
        location.title = self.title
        location.type = self.type
        location.distance = self.distance
        location.locationImage = self.locationImage
        location.locationID = self.locationID
        return location
    }
}
