//
//  MSGlobals.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/21/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

/**
    A file for extensions and any hardcoded strings (meta data, localized keys)
 **/

import Foundation
import UIKit

// Create get-only property for the app's detail color. Can now be called along with .red, .blue, etc.
public extension UIColor{
    public static var detailColor:UIColor{
        get{
            return UIColor.init(red: 255/255, green: 128/255, blue: 128/255, alpha: 1.0)
        }
    }
    
    //Example of a get-set pattern. Rarely used
    private static var _themeColor:UIColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
    public static var themeColor:UIColor{
        get{
            return UIColor._themeColor
        }
        set{
            UIColor._themeColor = newValue
        }
    }
}

// Remove first collection element that is equal to the given `object`:
public extension Array where Element: Equatable {
    mutating func removeWithObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

//Determine if the device has a 'safe area' i.e. face recognition housing i.e. is an iPhone X. Done more cleanly in IB.
public extension UIApplication {
    static var deviceHasSafeArea:Bool {
        if #available(iOS 11.0, *) {
            if let topPadding = shared.keyWindow?.safeAreaInsets.top{
                return topPadding > 0
            }
        }
        return false
    }
}

public enum GlobalStrings: String {
    case GlobalThemeChanged  = "com.mapstack.themeWasChanged"
    case FavoriteUpdated     = "com.mapstack.favoritesUpdated"
    case FavoritesRearranged = "com.mapstack.favoritesOrderRearranged"
    case FavoritesArray      = "com.mapstack.favoritesArray"
}


