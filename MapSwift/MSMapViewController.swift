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
    static let statusBarHeight = CGFloat(64)
    static let TabBarHeight    = CGFloat(49)
    static let titlePadding    = CGFloat(5)
    //For iPhone X. Easier and cleaner to achieve if using IB
    static let safeAreaPadding = UIApplication.deviceHasSafeArea ? CGFloat(20.0) : CGFloat(0.0)
}

private enum locationDownloadFailures:String{
    case noNetwork = "com.MapSwift.locationDownloadFailures.noNetwork"
    case badJson = "com.MapSwift.locationDownloadFailures.badJson"
}

class MSMapViewController: MSViewController {
    
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
    }
    
    //MARK: lazy getters
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
        let url = URL.init(string: "https://mikeleveton.com/MapStackLocations.json")
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
        return manager
    }
    
    lazy var map:MKMapView = self.newMap()
    func newMap() -> MKMapView{
        let map = MKMapView()
        map.frame = self.mapFrame()
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
    
    lazy var titleLabel:UILabel = self.newTitleLabel()
    func newTitleLabel() -> UILabel{
        let label = UILabel()
        label.text   = "MapSwift"
        label.sizeToFit()
        label.frame.size.width  = self.view.frame.width
        label.frame.origin.y = Constants.statusBarHeight + Constants.safeAreaPadding
        label.textAlignment = .center
        label.textColor = UIColor.white
        self.view.addSubview(label)
        return label
    }
    
    func mapFrame() -> CGRect{
        var mapFrame = CGRect.zero
        mapFrame.size = CGSize(width: view.frame.size.width, height: (view.frame.height - self.titleLabel.frame.maxY + Constants.titlePadding))
        
        /* Calculate the map's position of the view using Core Graphic helper methods */
        let mapOrigin = CGPoint(x: 0, y: self.titleLabel.frame.maxY + Constants.titlePadding)
        mapFrame.origin = mapOrigin
        
        return  mapFrame;
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
        
        /**
         convert it to bytes.
         Could use the new JSONDecoder method here but we want to demonstrate guard chaining.
         */
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            /** serialize the bytes into a dictionary object */
            self.layoutMapWithData(data: jsonData)
            
            /** jsonData was nil, fail gracefully */
        } catch _ {
            handleLocationFailure(failureType: .badJson)
            return
        }
    }
    
    func populateMap(){
        
        /**
         URLSessionDataTask returns data directly to the app in a closure. This time, the closure is exectuted when the response comes from the server.
         I like to lowercase closure variables so that you can guess it's type.
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
                        if let theData = data{
                            self.layoutMapWithData(data:theData)
                        }
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
            
            guard
                let jsonDict = jsonResponse as? Dictionary<AnyHashable, AnyObject>,
                let locationDictionaries:Array = (jsonDict["MapStackLocationsArray"]) as? [Dictionary<AnyHashable,Any>],
                /* Populate the favorites vc */
                let favs = UserDefaults.standard.object(forKey: GlobalStrings.FavoritesArray.rawValue) as? Array<Int>
                else {return}
            
            var favsDataSource = [MSLocation]()
            
            for x in 0..<locationDictionaries.count{
                guard let location = MSLocation.serializeLocationWith(dict: locationDictionaries[x]) else {return}
                
                map.addAnnotation(location)
                self.datasource.append(location)
                
                //Use if let here because we still want execution to continue
                if let locID = location.locationID {
                    if favs.contains(locID){
                        favsDataSource.append(location)
                    }
                }
                
                
                /* uncomment to see how copying an object would work */
                //                let newloc = location.copy() as? MSLocation
                //                if let newloc = newloc{
                //                    newloc.type = "foo"
                //                    print("newloc \(String(describing: newloc.type)) oldloc \(String(describing: location.type))")
                //                }
            }
            
            guard
                let viewControllers = self.tabBarController?.viewControllers,
                let locationsVC:MSLocationsViewController = viewControllers[1] as? MSLocationsViewController,
                let nav:UINavigationController = viewControllers[2] as? UINavigationController,
                let favsVC:MSFavoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController
                else{return}
            
            locationsVC.dataSource = self.datasource
            favsVC.dataSource = favsDataSource
            self.map.isHidden = false
            
        } catch {
            //This closure is called if JSONSerialization.jsonObject() errors out. Nothing after JSONSerialization.jsonObject would be executed
            print("json failed")
        }
    }
    
    fileprivate func handleLocationFailure(failureType:locationDownloadFailures){
        var msg = ""
        switch failureType {
        case .noNetwork:
            msg = NSLocalizedString("No Network", comment:"")
        case .badJson:
            msg = NSLocalizedString("Bad JSON", comment:"")
        }
        let alert = UIAlertController(title:msg, message:NSLocalizedString("Try again in a moment", comment:""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment:""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated:true, completion:nil)
    }
}
