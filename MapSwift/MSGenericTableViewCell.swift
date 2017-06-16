//
//  MSGenericTableViewCell.swift
//  MapSwift
//
//  Created by Mike Leveton on 6/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

protocol Reusable{
    //the get in brackets means it's read-only
    static var identifier: String { get }
}

//we want to configure 'identifier' so we extend reusable
extension Reusable {
    static var identifier:String{
        //Self is the thing conforming to the protocol, for us, a subclass of UITableViewCell
        print("cell id: \(Self.self)")
        
        //lowercase self is the Self's type, for us, 3 different possibilities
        //String() converts the type's name into a string.
        return String(describing: Self.self)
    }
}

class MSColorTableViewCell:UITableViewCell, Reusable{
    
}
class MSTypeTableViewCell:UITableViewCell, Reusable{
    
}
class MSDistanceTableViewCell:UITableViewCell, Reusable{
    
}

//we extend UITableView to add properties and methods to an exiting class
extension UITableView{
    //the angle brackets say that whatever is returned MUST conform to the Reusable protocol
    func reusableCell<T: Reusable>(indexPath:IndexPath) -> T {
        //this allows us to create an identifier that matches the class's name
        return self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    //T.Type is way you pass Foo.self as a parameter
    //where clause allows you to filter. in this case, T must be a UITableViewCell that conforms to Reusable
    func registerCell<T: UITableViewCell>(_:T.Type) where T: Reusable{
        //.self allows us to access the class NOT the instance.
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
}
