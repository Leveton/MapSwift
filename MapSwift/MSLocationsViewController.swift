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
    
    var dataSource:Array<MSLocation>?{
        didSet{
            self.tableView.reloadData()
            
            guard let tab = self.tabBarController?.viewControllers else{
                //fail gracefully
                return
            }
            
            guard let nav:UINavigationController = tab[2] as? UINavigationController else{
                //fail gracefully
                return
            }
            guard let vc:MSFavoritesViewController = nav.viewControllers[0] as? MSFavoritesViewController else{
                //fail gracefully
                return
            }
            
            if let datasource = dataSource{
              vc.dataSource = datasource
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
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = self.dataSource?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as UITableViewCell
        cell.textLabel?.text = location?.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.dataSource?[indexPath.row]
        let vc = MSLocationDetailViewController()
        vc.location = location
        vc.view.backgroundColor = UIColor.red
        self.present(vc, animated: true, completion: nil)
    }
}
