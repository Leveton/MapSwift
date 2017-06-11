//
//  MSLocationsViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/10/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

private struct Constants {
    static let TableViewPadding = CGFloat(20)
}

class MSLocationsViewController: MSViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellID = "CellIdentifier"
    
    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        return tableView
    }
    
    var dataSource:Array<MSLocation>!{
        didSet{
            /* 
             Did set only gets called once so you won't have an infinite loop here.
             Uncomment sorting by title to get the MDC locations in alphabetical order. Or use a more advanced sorting filter.
             */
            
            self.tableView.reloadData()
            //grab array of view controllers. those things at the bottom
            //let tab = self.tabBarController?.viewControllers
            
            //3rd vc is a nav controller. allowing u to push and pop
            //let nav = tab?[2] as! UINavigationController
            
            //nav also has array of vc's y we grabbed the root or 0 vc and then set it's data source
            //let vc = nav.viewControllers[0] as! MSFavoritesViewController
            
            //this is a SETTER. it's didSet{} in favs vc now gets called and copiedDataSource gets set
            //vc.dataSource = dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var tableViewFrame = self.tableView.frame
        tableViewFrame.origin.x = Constants.TableViewPadding
        tableViewFrame.origin.y = Constants.TableViewPadding
        tableViewFrame.size.width = self.view.frame.width - (Constants.TableViewPadding * 2)
        tableViewFrame.size.height = self.view.frame.height - (Constants.TableViewPadding * 2) - 48.0
        self.tableView.frame = tableViewFrame
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let location = self.dataSource[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as UITableViewCell
//        cell.textLabel?.text = location.title
//        return cell
//    }

    /* uncomment this and return 1000 in numberOfRowsInSection to show a hundreds reused rows */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = self.dataSource[indexPath.row]
        let str:String = "cellid"
        var cell = tableView.dequeueReusableCell(withIdentifier: str)
        
        if (cell == nil){
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: str)
            //print("new cell")
        }else{
            //print("old cell")
        }
        cell?.textLabel?.text = location.title
        cell?.detailTextLabel?.text = NSString(format: "distance: %f", (location.distance)!) as String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.dataSource[indexPath.row]
        let vc = MSLocationDetailViewController()
        vc.location = location
        vc.view.backgroundColor = UIColor.red
        vc.isPresented = true
        self.present(vc, animated: true, completion: nil)
    }
}
