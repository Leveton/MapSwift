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
        
        var dict:Dictionary<Int,String>?
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
    
    func fuck(dd: Dictionary<Int, String>){
        
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
        
        /** grab the local json file */
        let jsonFile = Bundle.main.path(forResource: "MapStackLocations", ofType: "json")
        guard let file = jsonFile else{
            return
        }
        let jsonURL = URL(fileURLWithPath: file)
        
        /**convert it to bytes*/
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            do {
                /** serialize the bytes into a dictionary object */
                let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
                
                guard let jsonDict = jsonResponse as? Dictionary<AnyHashable, AnyObject> else{
                    //fail gracefully
                    return
                }
                if let locationDictionaries = (jsonDict["MapStackLocationsArray"] as? [Dictionary<AnyHashable,Any>]){
                    for dict in locationDictionaries{
                        if let obj = createLocationWithDictionary(dict: dict){
                            //self.datasource.append(obj)
                        }
                    }
                }
                
                guard let viewControllers = self.tabBarController?.viewControllers else{
                    //fail gracefully
                    return
                }
                guard let vc:MSLocationsViewController = viewControllers[1] as? MSLocationsViewController else{
                    //fail gracefully
                    return
                }
                //vc.dataSource = self.datasource
                
            } catch {
                //fail gracefully
            }
            
        } catch {
            //fail gracefully
        }
        
    }
    
    func createLocationWithDictionary(dict:Dictionary<AnyHashable,Any>) -> MSLocation?{
        return MSLocation(coordinate: self.centerPoint)
    }
}
