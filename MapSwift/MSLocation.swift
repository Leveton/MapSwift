//
//  MSLocation.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/17/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit
import MapKit

//Must be a class so we can conform to MKAnnotation and show details on our map
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
}

//For models, keep properties separate from methods.
extension MSLocation{
    /*
     Models serialize themselves.
     we want to return nil (and thus not include it in our data source) if either the distance or the coordinates fail to serialize. The other properties are not mission critical and so can be nil
     */
    static func serializeLocationWith(dict:Dictionary<AnyHashable, Any>) -> MSLocation?{
        guard
            
            let dist = dict["distance"] as? CGFloat,
            
            let lat = dict["latitude"] as? CLLocationDegrees,
            
            let long = dict["longitude"] as? CLLocationDegrees
                else {return nil}
            
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude  = lat
        coordinate.longitude = long
        
        let location = MSLocation(coordinate: coordinate, distance:dist)
        location.subtitle = "dist: \(String(describing: dist))"
        
        /* we'll allow the rest of our properties to be possibly nil */
        location.locationID = dict["locationId"] as? Int
        location.title = dict["name"] as? String
        location.type = dict["type"] as? String
        
        /*make sure the string exists and is the right type before trying to build the image with the string */
        if let imgStr = dict["image"] as? String{
            if let image = UIImage(named:imgStr){
                location.locationImage = image
            }
        }
        
        return location
    }
    
    public func getDistanceFromPoint(pointA:CLLocationCoordinate2D, pointB:CLLocationCoordinate2D) -> Double{
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
