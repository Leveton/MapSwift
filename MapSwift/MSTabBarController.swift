//
//  MSTabBarController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/23/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSTabBarController: UITabBarController {

    var favoritesViewController:MSFavoritesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: selectors
    
    public func removeLocationFromFavoritesWithLocation(location: MSLocation){
        
        let nav = self.viewControllers![2] as! UINavigationController
        self.favoritesViewController = nav.viewControllers[0] as! MSFavoritesViewController
        var favs = self.favoritesViewController.dataSource
        favs.removeWithObject(object: location)
        self.favoritesViewController.dataSource = favs
    }
    
    public func addLocationToFavoritesWithLocation(location: MSLocation){
        let nav = self.viewControllers![2] as! UINavigationController
        self.favoritesViewController = nav.viewControllers[0] as! MSFavoritesViewController
        var favs = self.favoritesViewController.dataSource
        favs.append(location)
        self.favoritesViewController?.dataSource = favs
    }
}
