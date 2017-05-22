//
//  MSMapViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/29/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit
import MapKit

private struct Constants {
    static let MapSide = CGFloat(300)
    static let TabBarHeight = CGFloat(49)
}

class MSMapViewController: MSViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.startUpdatingLocation()
        
        /* 1 mile radius */
        let adjustedRegion = self.map.regionThatFits(MKCoordinateRegionMakeWithDistance(self.centerPoint, 1609.34, 1609.34))
        self.map.setRegion(adjustedRegion, animated: true)
        
        let location = MSLocation(coordinate:self.centerPoint)
        var newPoint = CLLocationCoordinate2D()
        newPoint.latitude  = 15.777599
        newPoint.longitude = 70.190793
        let distance = location.getDistanceFromPoint(pointA: self.centerPoint, pointB: newPoint)
        print("distance \(distance)")
        
        populateMap()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: getters
    lazy var manager:CLLocationManager = self.newManager()
    func newManager() -> CLLocationManager{
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        return manager
    }
    
    lazy var map:MKMapView = self.newMap()
    func newMap() -> MKMapView{
        let map = MKMapView()
        map.frame = self.mapFrame()
        map.delegate = self
        map.showsUserLocation = true
        self.view.addSubview(map)
        return map
    }
    
    lazy var centerPoint:CLLocationCoordinate2D = self.newCenterPoint()
    func newCenterPoint() -> CLLocationCoordinate2D{
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude  = 25.777599;
        coordinate.longitude = -80.190793;
        return coordinate;
    }
    
    func mapFrame() -> CGRect{
        
        var mapFrame = CGRect.zero
        mapFrame.size = CGSize(width: Constants.MapSide, height: Constants.MapSide)
        
        /* Calculate the map's position of the view using Core Graphic helper methods */
        let xOffset = (self.view.frame.width - Constants.MapSide)/2
        let yOffset = (self.view.frame.height - Constants.MapSide)/2
        let mapOrigin = CGPoint(x: xOffset, y: yOffset)
        mapFrame.origin = mapOrigin
        
        return  mapFrame;
    }
    
    //MARK: MKMapViewDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    //MARK: selectors
    
    func populateMap(){
        //Bundle is all the stuff in our project
        
        let jsonFile = Bundle.main.path(forResource:"MapStackLocations", ofType: "json")
        
        //let's make sure jsonFile is not nil
        if let jsonFile = jsonFile{
            //get a url with the file.
            let jsonURL = URL(fileURLWithPath: jsonFile)
            //jsonData could be nil, hence the question mark
            let jsonData: Data?
            do {
                //a byte stream
                jsonData = try Data(contentsOf: jsonURL)
                print("json data \(String(describing: jsonData))")
                
            } catch{
                jsonData = nil
            }
            if let jsonData = jsonData{
                print("json data \(jsonData)")
                let jsonResponse:AnyObject
                do {
                    try jsonResponse = JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
                    let jsonDict = jsonResponse as! Dictionary<AnyHashable, AnyObject>
                    //first bang is saying that jsonDict["some key"] exists i swear on my family, second bang is promising that locationdictiionaries exists
                    let locationDictionaries = (jsonDict["MapStackLocationsArray"])! as! [NSDictionary]
                    
                    for x in 0..<locationDictionaries.count{
                        let dict = locationDictionaries[x]
                        let location = self.createLocationWithDictionary(dict: dict)
                        map.addAnnotation(location)
                    }
                    print("dicts \(locationDictionaries)")
                } catch{
                    print("json failed")
                }
            }
        }
    }
    
    func createLocationWithDictionary(dict: NSDictionary) -> MSLocation{
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = dict.object(forKey: "latitude") as! CLLocationDegrees
        coordinate.longitude = dict.object(forKey: "longitude") as! CLLocationDegrees
        
        let location = MSLocation(coordinate: coordinate)
        location.locationID = dict.object(forKey: "locationId") as? Int
        location.title = dict.object(forKey: "name") as? String
        location.type = dict.object(forKey: "type") as? String
        location.distance = dict.object(forKey: "distance") as? CGFloat
        location.coordinate = coordinate
        location.subtitle = "this is a subtile"
        return location
    }
}
