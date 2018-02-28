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
private enum locationDownloadFailures:String{
    case noNetwork = "com.MapSwift.locationDownloadFailures.noNetwork"
    case badJson = "com.MapSwift.locationDownloadFailures.badJson"
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
    
    lazy var progressView:UIActivityIndicatorView = self.newProgressView()
    func newProgressView() -> UIActivityIndicatorView{
        let view = UIActivityIndicatorView()
        view.frame = self.mapFrame()
        view.layer.zPosition = 2.0
        view.isHidden = true
        self.view.addSubview(view)
        return view
    }
    
    lazy var locationsRequest:URLRequest? = self.newLocationsRequest()
    func newLocationsRequest() -> URLRequest?{
        /**
         As of iOS 9, apple requires that API endpoint use SSL. Were I to serve this API via HTTP, the download would fail unless you executed a specific hack (Google app transport security for details on this).
         */
        let url = URL.init(string: "http://mikeleveton.com/MapStackLocations.json")
        if let url = url{
            return URLRequest(url: url)
        }else{
            return nil
        }
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
        coordinate.latitude  = 25.777599
        coordinate.longitude = -80.190793
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
        /** make sure it's not nil **/
        guard let file = jsonFile else{
            handleLocationFailure(failureType: .badJson)
            return
        }
        let jsonURL = URL(fileURLWithPath: file)
        /**convert it to bytes*/
        let jsonData: Data?
        do {
            jsonData = try Data(contentsOf: jsonURL)
            /** serialize the bytes into a dictionary object */
            if let jsonData = jsonData{
                self.layoutMapWithData(data: jsonData)
            }else{
                handleLocationFailure(failureType: .badJson)
            }
        /** jsonData was nil, fail gracefully */
        } catch _ {
            jsonData = nil
            handleLocationFailure(failureType: .badJson)
            return
        }
    }
    
    func populateMap(){
        
        /**
         URLSessionDataTask returns data directly to the app in a block. This time, the block is exectuted when the response comes from the server.
         I like to lowercase block variables so that you can guess it's type.
         App transport security hack is required here.
         */
        
        self.progressView.isHidden = false
        self.progressView.startAnimating()
        
        if let request = self.locationsRequest{
            let locationTask:URLSessionDataTask = self.sessionlocations.dataTask(with:
                request, completionHandler:
                {(data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        self.progressView.stopAnimating()
                        self.progressView.isHidden = true
                        self.layoutMapWithData(data: data!)
                    }
                    
            })
            
            locationTask.resume()
        }else{
            getLocalData()
        }
        
        //
        
    }
    
    /* let's abstract reused code into one method */
    func layoutMapWithData(data:Data){
        
        /** serialize the bytes into a dictionary object */
        let jsonResponse:AnyObject
        do {
            try jsonResponse = JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            let jsonDict = jsonResponse as! Dictionary<AnyHashable, AnyObject>
            let locationDictionaries = (jsonDict["MapStackLocationsArray"])! as! [NSDictionary]
            
            /* Populate the favorites vc */
            let favs = UserDefaults.standard.object(forKey: "favoritesArray") as! Array<Int>
            var favsDataSource = [MSLocation]()
            
            for x in 0..<locationDictionaries.count{
                let dict = locationDictionaries[x] as NSDictionary
                let location:MSLocation = self.createLocationWithDictionary(dict: dict)
                self.datasource.append(location)
                if favs.contains(location.locationID!){
                    favsDataSource.append(location)
                }
                
                /* uncomment to see how copying an object would work */
                //                    let newloc = location.copy() as! MSLocation
                //                    newloc.type = "foo"
                //                    print("newloc \(String(describing: newloc.type)) oldloc \(String(describing: location.type))")
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
    
    func createLocationWithDictionary(dict: NSDictionary) -> MSLocation{
        let fl = dict.object(forKey: "distance") as? CGFloat
        if let fl = fl{
            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude  = dict.object(forKey: "latitude") as! CLLocationDegrees
            coordinate.longitude = dict.object(forKey: "longitude") as! CLLocationDegrees
            
            let location = MSLocation(coordinate: coordinate, distance:fl)
            location.subtitle = "dist: \(String(describing: fl))"
            location.locationID = dict.object(forKey: "locationId") as? Int
            location.title = dict.object(forKey: "name") as? String
            location.type = dict.object(forKey: "type") as? String
            location.coordinate = coordinate
            
            let image = UIImage(named: dict.object(forKey: "image") as! String)
            location.locationImage = image
            
            map.addAnnotation(location)
            
            return location
        }else{
            //default to no distance
            return MSLocation(coordinate: CLLocationCoordinate2D(), distance: 0.0)
        }
    }

    fileprivate func handleLocationFailure(failureType:locationDownloadFailures){
        var msg = ""
        switch failureType {
        case .noNetwork:
            msg = NSLocalizedString("No Network", comment:"")
        case .badJson:
            msg = NSLocalizedString("Bad JSON", comment:"")
//        default:
//            msg = NSLocalizedString("Something happened", comment:"")
        }
        let alert = UIAlertController(title:msg, message:NSLocalizedString("Try again in a moment", comment:""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment:""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated:true, completion:nil)
    }
}
