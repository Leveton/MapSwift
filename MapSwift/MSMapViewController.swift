//
//  MSMapViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 3/29/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit
import MapKit

class MSMapViewController: MSViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    lazy var manager:CLLocationManager = self.newManager()
    
    func newManager() -> CLLocationManager{
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        return manager
    }
    
    lazy var map:MKMapView = self.newMap()
    func newMap() -> MKMapView{
        return MKMapView()
    }
    
    func mapFrame() -> CGRect{
        
          let mapFrame = CGRect.zero
          //mapFrame.size = CGSize.
//        /* use 2 floats defined at the top to set the map's size (it's width and height) */
//        CGRect mapFrame        = CGRectZero;
//        mapFrame.size          = CGSizeMake(kMapSide, kMapSide);
//        
//        /* Calculate the map's position of the view using Core Graphic helper methods */
//        CGFloat xOffset        = (CGRectGetWidth([[self view] frame]) - kMapSide)/2;
//        CGFloat yOffset        = ((CGRectGetHeight([[self view] frame]) - kTabbarHeight) - kMapSide)/2;
//        CGPoint mapOrigin      = CGPointMake(xOffset, yOffset);
//        mapFrame.origin        = mapOrigin;
        
        return  mapFrame;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.startUpdatingLocation()
        //let adjustedRegion:MKCoordinateRegion =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
