//
//  MSFavoritesViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSFavoritesViewController: UITableViewController {

    var dataSource = [MSLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //save the user's name for access in other modules
        UserDefaults.standard.set("Mike", forKey: "userName")
        
        //access this in other modules
        print("user name: \(UserDefaults.standard.object(forKey: "userName") as! String)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location:MSLocation = self.dataSource[indexPath.row]
        let iden = "FavsCell"
        // if the ref to deqeueReuse is nil, create a new UITableViewCell()
        let cell:MSFavoritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: iden) as? MSFavoritesTableViewCell ?? MSFavoritesTableViewCell(style: .subtitle, reuseIdentifier: iden)
        //cell.label.text = location.title
        //cell.detailTextLabel?.text = "dist: \(location.distance)"
        cell.imageView?.image = location.locationImage
        return cell
    }

}
