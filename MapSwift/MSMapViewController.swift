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
    
    lazy var datasource:Array<MSLocation> = self.newDatasource()
    func newDatasource() -> Array<MSLocation>{
        return Array()
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
        
        /** grab the local json file */
        let jsonFile = Bundle.main.path(forResource: "MapStackLocations", ofType: "json")
        let jsonURL = URL(fileURLWithPath: jsonFile!)
        
        /**convert it to bytes*/
        let jsonData: Data?
        do {
            jsonData = try Data(contentsOf: jsonURL)
            
        } catch _ {
            jsonData = nil
        }
        
        /** serialize the bytes into a dictionary object */
        let jsonResponse:AnyObject
        do {
            try jsonResponse = JSONSerialization.jsonObject(with: jsonData!, options: []) as AnyObject
            let jsonDict = jsonResponse as! Dictionary<AnyHashable, AnyObject>
            print("json response \(jsonResponse)")
            let locationDictionaries = (jsonDict["MapStackLocationsArray"])! as! [NSDictionary]
            print("json dictionaries \(locationDictionaries)")
            for x in 0..<locationDictionaries.count{
                self.datasource.append(createLocationWithDictionary(dict: locationDictionaries[x] as NSDictionary))
            }
            
            let viewControllers = self.tabBarController?.viewControllers
            let vc:MSLocationsViewController = viewControllers![1] as! MSLocationsViewController
            vc.dataSource = self.datasource
            
        } catch {
            print("json failed")
        }
        
    }
    
    func createLocationWithDictionary(dict: NSDictionary) -> MSLocation{
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude  = dict.object(forKey: "latitude") as! CLLocationDegrees
        coordinate.longitude = dict.object(forKey: "longitude") as! CLLocationDegrees
        
        let location = MSLocation(coordinate: coordinate)
        location.locationID = dict.object(forKey: "locationId") as? Int
        location.title = dict.object(forKey: "name") as? String
        location.type = dict.object(forKey: "type") as? String
        location.distance = dict.object(forKey: "distance") as? CGFloat
        location.coordinate = coordinate
        
        let image = UIImage(named: dict.object(forKey: "image") as! String)
        location.locationImage = image
        
        map.addAnnotation(location)
        
        return location
    }
}
