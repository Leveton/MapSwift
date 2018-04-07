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
    var copiedDataSource:Array = [MSLocation]()
    
    var range:MSRange?{
        //didSet allows you to be reactive
        didSet{
            self.sortByDistance()
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        return tableView
    }
    
    var dataSource:Array = [MSLocation](){
        didSet{
            /* 
             Did set only gets called once so you won't have an infinite loop here.
             Uncomment sorting by title to get the MDC locations in alphabetical order. Or use a more advanced sorting filter.
             */
            
            if range == nil{
                self.copiedDataSource = self.dataSource
                self.dataSource.sort{$0.distance < $1.distance}
                self.tableView.reloadData()
            }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as UITableViewCell
        cell.textLabel?.text = location.title
        return cell
    }

    /* uncomment this and return 1000 in numberOfRowsInSection to show a hundreds reused rows */
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let str:String = "cellid"
//        var cell = tableView.dequeueReusableCell(withIdentifier: str)
//        if let cell = cell {
//            print("old cell")
//            if let textLabel = cell.textLabel {
//                textLabel.text = "row: \(indexPath.row)"
//            }
//            return cell
//        }else{
//            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: str)
//            print("new cell")
//            /*something in the system went horribly wrong if there's still not a cell */
//            return cell ?? UITableViewCell()
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.dataSource[indexPath.row]
        let vc = MSLocationDetailViewController()
        vc.location = location
        vc.view.backgroundColor = UIColor.detailColor
        vc.isViewPresented = true
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: selectors
    
    private func sortByDistance(){
        if let theRange = range{
            /* sort by range as selected in settings */
            self.dataSource = self.copiedDataSource
            
            /* notice that we can chain filters to create a range of value */
            self.dataSource = self.dataSource.filter{Float($0.distance) > theRange.startPoint}.filter{Float($0.distance) < theRange.endPoint}
            
        }else{
            /* sort by distance from highest to lowest */
            self.dataSource.sort{$0.distance < $1.distance}
        }
    }
}
