//
//  MSTabBarController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/23/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSTabBarController: UITabBarController {
    
    var favoritesViewController:MSFavoritesViewController?
    //var favoritesHolder = [MSLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: selectors
    
    func updateFavorites(favs:Array<MSLocation>, withRemoval:Bool, location:MSLocation){
        let nav = self.viewControllers?[2] as! UINavigationController
        self.favoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController
        var favs:Array<MSLocation> = self.favoritesViewController!.dataSource
        if withRemoval{
            favs.removeWithObject(location)
        }else{
            favs.append(location)
        }
        self.favoritesViewController?.dataSource = favs
        self.favoritesViewController?.copiedDataSource = favs
    }
    
    public func removeLocationFromFavoritesWithLocation(location: MSLocation){
        let nav = self.viewControllers?[2] as! UINavigationController
        self.favoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController
        updateFavorites(favs: self.favoritesViewController!.dataSource, withRemoval: true, location: location)
    }
    
    public func addLocationToFavoritesWithLocation(location: MSLocation){
        let nav = self.viewControllers?[2] as! UINavigationController
        self.favoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController
        updateFavorites(favs: self.favoritesViewController!.dataSource, withRemoval: false, location: location)
    }
}
