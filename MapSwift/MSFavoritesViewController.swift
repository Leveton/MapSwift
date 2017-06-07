//
//  MSFavoritesViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSFavoritesViewController: UITableViewController, MSTableViewCellDelegate {

    var dataSource = [MSLocation](){
        didSet{
            
            //bc it's storyboard, we need make sure it exists.
            if self.tableView != nil{
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func deleteButtonTappedFrom(cell: MSTableViewCell, location:MSLocation){
        
    }
    
    func detailButtonTappedFrom(cell: MSTableViewCell, location:MSLocation){
        //to show how we can reuse objects for multiple things y to show push navigation.
        let vc = MSLocationDetailViewController()
        vc.location = location
        vc.view.backgroundColor = UIColor.purple
        //here we push, not present
        vc.isPresented = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = self.dataSource[indexPath.row]
        let iden = "MSTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: iden) as? MSTableViewCell ?? MSTableViewCell(style: .subtitle, reuseIdentifier: iden)
        cell.delegate = self
        cell.location = location
        cell.mainLabel.text = location.title
        cell.subLabel.text = "dist: \(String(describing: location.distance))"
        cell.typeLabel.text = location.type
        cell.locationImageView.image = location.locationImage
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
