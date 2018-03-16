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
    var themeColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
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
