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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //We'll use the same map frame to keep our label seperate from our map
        var labelFrame:CGRect  = mapFrame()
        labelFrame.origin      = CGPoint(x: 0, y: 0)
        labelFrame.size.width  = self.view.frame.width
        labelFrame.size.height = labelFrame.size.height/2
        self.titleLabel.frame  = labelFrame
    }
    //MARK: getters
    
    lazy var titleLabel:UILabel = self.newTitleLabel()
    func newTitleLabel() -> UILabel{
        let label = UILabel()
        label.text   = "MapSwift"
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }
    
    lazy var progressView:UIActivityIndicatorView = self.newProgressView()
    func newProgressView() -> UIActivityIndicatorView{
        let view = UIActivityIndicatorView()
        view.frame = self.mapFrame()
        view.layer.zPosition = 2.0
        view.isHidden = true
        self.view.addSubview(view)
        return view
    }
    
    lazy var locationsRequest:NSMutableURLRequest? = self.newLocationsRequest()
    func  newLocationsRequest() -> NSMutableURLRequest?{
        /**
         As of iOS 9, apple requires that API endpoint use SSL. Were I to serve this API via HTTP, the download would fail unless you executed a specific hack (Google app transport security for details on this).
         */
        
        let url = URL.init(string: "https://mikeleveton.com/MapStackLocations.json")
        if let url = url{
          return NSMutableURLRequest(url: url)
        }
        return nil
    }
    
    /* URLSession is a large and rich API for downloading data */
    lazy var sessionlocations:URLSession = self.newSessionLocations()
    func newSessionLocations() -> URLSession{
        
        /**
         use the default session configuration because we want the code executed immediately (not on a background thread like backgroundSessionConfigurationWithIdentifier), and, because the data's not sensitive, we want it to be cached (which ephemeral session doesn't do)
         */
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }
    
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
        map.isHidden = true
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
    
    func getLocalData(){
        /** grab the local json file */
        let jsonFile = Bundle.main.path(forResource: "MapStackLocations", ofType: "json")
        
        if let jsonFile = jsonFile{
            let jsonURL = URL(fileURLWithPath: jsonFile)
            
            /**convert it to bytes*/
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                /** serialize the bytes into a dictionary object */
                self.layoutMapWithData(data: jsonData)
                
            } catch _ {
                //fail gracefully
            }
        }else{
            //fail gracefully
        }
    }
    
    func populateMap(){
        
        /**
         URLSessionDataTask returns data directly to the app in a block. This time, the block is exectuted when the response comes from the server.
         I like to lowercase block variables so that you can guess it's type.
         App transport security hack is required here.
         */
        guard let locationsRequest = self.locationsRequest else{
            return
        }
        self.progressView.isHidden = false
        self.progressView.startAnimating()
        
        let locationTask:URLSessionDataTask = self.sessionlocations.dataTask(with:
            locationsRequest as URLRequest, completionHandler:
            {(data, response, error) -> Void in
            
            //print("sess locs \(self.sessionlocations) sess req \(self.locationsRequest)")
                guard error == nil else{
                    return
                }
                guard let data = data else{
                    return
                }
                DispatchQueue.main.async {
                    self.progressView.stopAnimating()
                    self.progressView.isHidden = true
                    self.layoutMapWithData(data: data)
                }
        })

        locationTask.resume()
        
        //getLocalData()
        
    }
    
    /* let's abstract reused code into one method */
    func layoutMapWithData(data:Data){
        
        /** serialize the bytes into a dictionary object */
        let jsonResponse:AnyObject
        do {
            try jsonResponse = JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            guard let jsonDict = jsonResponse as? Dictionary<AnyHashable, AnyObject> else{
                //fail gracefully
                return
            }
            
            guard let locationDictionaries:Array = (jsonDict["MapStackLocationsArray"]) as? [Dictionary<AnyHashable,Any>] else{
                //fail gracefully
                return
            }
            
            /* Populate the favorites vc */
            guard let favs = UserDefaults.standard.object(forKey: "favoritesArray") as? Array<Int> else{
                //fail gracefully
                return
            }
            var favsDataSource = [MSLocation]()
            
            for loc in locationDictionaries{
                if let location = createLocationWithDictionary(dict:loc){
                    map.addAnnotation(location)
                    self.datasource.append(location)
                    
                    if let locID = location.locationID{
                        if favs.contains(locID){
                            favsDataSource.append(location)
                        }
                    }
                }
                
                /* uncomment to see how copying an object would work */
                //                let newloc = location.copy() as? MSLocation
                //                if let newloc = newloc{
                //                    newloc.type = "foo"
                //                    print("newloc \(String(describing: newloc.type)) oldloc \(String(describing: location.type))")
                //                }
            }
            
            guard let viewControllers = self.tabBarController?.viewControllers else{
                //fail gracefully
                return
            }
            
            guard let locationsVC:MSLocationsViewController = viewControllers[1] as? MSLocationsViewController else{
                //fail gracefully
                return
            }
            guard let nav:UINavigationController = viewControllers[2] as? UINavigationController else{
                //fail gracefully
                return
            }
            guard let favsVC:MSFavoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController else{
                //fail gracefully
                return
            }
            
            locationsVC.dataSource = self.datasource
            favsVC.dataSource = favsDataSource
            self.map.isHidden = false
            
        } catch {
            //This closure is called if JSONSerialization.jsonObject() errors out. Nothing after JSONSerialization.jsonObject would be executed
            print("json failed")
        }
    }
    
    /* we want to return nil (and thus not include it in our data source) if either the distance or the coordinates fail to serialize. The other properties are not mission critical and so can be nil */
    func createLocationWithDictionary(dict:Dictionary<AnyHashable, Any>) -> MSLocation?{
        guard let dist = dict["distance"] as? CGFloat else{
            return nil
        }
        guard let lat = dict["latitude"] as? CLLocationDegrees else{
            return nil
        }
        guard let long = dict["longitude"] as? CLLocationDegrees else{
            return nil
        }
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
    
}
