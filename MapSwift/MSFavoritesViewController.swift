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
    var dataSource = [MSLocation]()
    
    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //cell.textLabel?.text = location.title
        return cell!
    }

    //MARK: MSTableViewCellDelegate
    
    
    func deleteButtonTappedFrom(cell: MSTableViewCell){
        
    }
}
