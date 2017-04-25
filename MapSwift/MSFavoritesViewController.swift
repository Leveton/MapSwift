//
//  MSFavoritesViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSFavoritesViewController: MSViewController, UITableViewDelegate, UITableViewDataSource, MSTableViewCellDelegate {

    private let cellID = "CellIdentifier"
    @IBOutlet weak var tableView: UITableView!
    
    /* guarantee that dataSource is not nil */
    var dataSource = [MSLocation](){
        didSet{
            if self.tableView != nil{
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: cellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MSTableViewCell
        cell?.delegate = self
        cell?.location = location
        cell?.tag = indexPath.row
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    //MARK: MSTableViewCellDelegate
    
    
    func deleteButtonTappedFrom(cell: MSTableViewCell){
        
    }
}
