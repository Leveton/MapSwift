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
    @objc var distance:CGFloat
    var locationImage:UIImage?
    var locationID:Int?
    
    init(coordinate:CLLocationCoordinate2D, distance:CGFloat) {
        self.coordinate = coordinate
        self.distance = distance
    }
    
    func getDistanceFromPoint2(pointA:CLLocationCoordinate2D, pointB:CLLocationCoordinate2D) -> Double{
        /* if you square a negative number, you get a quiet nan */
        return sqrt(abs(((pointA.latitude - pointB.latitude) * (pointA.latitude - pointB.latitude)) + ((pointA.longitude - pointB.longitude) * (pointA.longitude - pointB.longitude))))
    }
    
    func copy(with zone: NSZone? = nil) -> Any{
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude  = 0
        coordinate.longitude = 0
        let location = MSLocation(coordinate: coordinate, distance: self.distance)
        location.title = self.title
        location.subtitle = self.subtitle
        location.type = self.type
        location.distance = self.distance
        location.locationImage = self.locationImage
        location.locationID = self.locationID
        return location
    }
}
