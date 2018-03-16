//
//  MSGlobals.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/21/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import Foundation
import UIKit

public class MSSingleton{
    static let sharedInstance = MSSingleton()
    var themeColor = UIColor.init(red: 0.208, green: 0.2, blue: 0.7, alpha: 1.0)
}

public extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func removeWithObject(object: Element) {
        print("looping thru array")
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

//Determine if the device has a 'safe area' i.e. face recognition housing i.e. is an iPhone X
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
