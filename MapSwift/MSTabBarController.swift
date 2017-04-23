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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: selectors
    
    public func removeLocationFromFavoritesWithLocation(location: MSLocation){
        var favs = self.favoritesViewController?.dataSource
        favs?.removeWithObject(object: location)
    }
    
    public func addLocationToFavoritesWithLocation(location: MSLocation){
        var favs = self.favoritesViewController?.dataSource
        favs?.append(location)
    }
}
