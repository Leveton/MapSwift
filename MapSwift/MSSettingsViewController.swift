//
//  MSSettingsViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

private enum Sections:Int{
    case ThemeColor = 0
    case TypeFilter
    case DistanceFilter
}

class MSSettingsViewController: MSViewController, UITableViewDelegate, UITableViewDataSource {

    required init(coder:NSCoder){
        super.init(coder: coder)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(MSViewController.handleThemeChange), name: NSNotification.Name(rawValue: GlobalStrings.FavoriteUpdated.rawValue), object: nil)
    }
    
    let cellID = "settingsCell"
    
    private var colorsArray = [String]()
    private var typesArray = [String]()
    private var distancesArray = [Double]()
    var locations = [MSLocation](){
        didSet{
            
        }
    }
    
    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        
        /* this table will be grouped - plain is the default */
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        tableView.allowsSelectionDuringEditing = true
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var tableFrame = self.tableView.frame
        tableFrame.origin.y = 20.0
        tableFrame.size.width = self.view.frame.width
        tableFrame.size.height = self.view.frame.height - 30.0
        self.tableView.frame = tableFrame
        
    }
    //MARK: UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.DistanceFilter.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.ThemeColor.rawValue{
            return self.colorsArray.count
        }
        if (section == Sections.TypeFilter.rawValue) {
            return self.typesArray.count
        }
        if (section == Sections.DistanceFilter.rawValue) {
            return self.distancesArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
