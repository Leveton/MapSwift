//
//  MSSettingsViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSSettingsViewController: MSViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        let tableView = UITableView(frame:CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }
    
    let sectionDict:[String:String] = [
    
        "0": NSLocalizedString("App Theme Color", comment: ""),
        "1": NSLocalizedString("Rearrange Favorite Types", comment: ""),
        "2": NSLocalizedString("Set Locations Range", comment: "")
    ]
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //when we called the getter to the right self.tableview, it called the lazy init to set everything up
        var tableFrame = self.tableView.frame
        tableFrame.origin.y = 20
        tableFrame.size.width = self.view.frame.size.width
        tableFrame.size.height = self.view.frame.height - 30.0
        self.tableView.frame = tableFrame
        
    }
    
    private var colorsArray = ["blue color", "green color", "orange color"]
    private var typesArray = ["Hospital", "School", "StartUp", "Random", "Restaurant"]
    private var distanceArray = [Double]()
    var locations = [MSLocation]()
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //this singleton will not be allocated more than once so it saves CPU cycles and memory
        self.view.backgroundColor = MSSingleton.sharedInstance.themeColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
