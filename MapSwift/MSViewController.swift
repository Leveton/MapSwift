//
//  MSViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/10/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

/* this is our base class. the four main view controllers are decended from this one. Keep this one very light! */
class MSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = MSSingleton.sharedInstance.themeColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleThemeChange(note: Notification) {
        view.backgroundColor = note.object as? UIColor
    }
}

public enum GlobalStrings: String {
    case GlobalThemeChanged  = "com.mapstack.themeWasChanged"
    case FavoriteUpdated     = "com.mapstack.favoritesUpdated"
    case FavoritesRearranged = "com.mapstack.favoritesOrderRearranged"
    case FavoritesArray      = "com.mapstack.favoritesArray"
}
