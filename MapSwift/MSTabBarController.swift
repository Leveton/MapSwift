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
        guard let nav = self.viewControllers?[2] as? UINavigationController else{
            return
        }
        self.favoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController
        guard let favs = self.favoritesViewController else{
            return
        }
        var data:Array<MSLocation> = favs.dataSource
        if withRemoval{
            data.removeWithObject(object:location)
        }else{
            data.append(location)
        }
        favs.dataSource = data
        favs.copiedDataSource = data
    }
    
    public func removeLocationFromFavoritesWithLocation(location: MSLocation){
        guard let nav = self.viewControllers?[2] as? UINavigationController else{
            return
        }
        self.favoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController
        guard let favs = self.favoritesViewController else{
            return
        }
        updateFavorites(favs: favs.dataSource, withRemoval: true, location: location)
    }
    
    public func addLocationToFavoritesWithLocation(location: MSLocation){
        guard let nav = self.viewControllers?[2] as? UINavigationController else{
            return
        }
        self.favoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController
        guard let favs = self.favoritesViewController else{
            return
        }
        updateFavorites(favs: favs.dataSource, withRemoval: false, location: location)
    }
}
