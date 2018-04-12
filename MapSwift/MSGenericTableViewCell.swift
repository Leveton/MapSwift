//
//  MSGenericTableViewCell.swift
//  MapSwift
//
//  Created by Mike Leveton on 6/11/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

protocol Reusable {
    //{ get } means the property is read-only, it cannot be modified
    static var reuseIdentifier: String { get }
}

//This extension allows anything conforming to Reusable to have a reuseIdentifier ready to go but still read-only.
extension Reusable {
    static var reuseIdentifier: String {
        // I like to use the class's name as an identifier
        // so this makes a decent default value.
        //print("reusable string \(Self.self)")
        
        //Self is the thing conforming to the protocol, in this case a subclass of UITableViewCell
        return String(describing: Self.self)
    }
}

class MSColorTableViewCell: UITableViewCell, Reusable {
    
}
class MSTypeTableViewCell: UITableViewCell, Reusable {
    
}
class MSDistanceTableViewCell: UITableViewCell, Reusable {
    
}

extension UITableView{
    // The angle brackets here declare that T is Reusable or conforms to Reusable
    func dequeueReusableCell<T: Reusable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    //T.type is how you ask for SomeClass.self
    //The where clause makes sure that it only registeres UITableViewCells that coform to Reusable
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

