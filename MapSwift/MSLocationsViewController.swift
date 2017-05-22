//
//  MSLocationsViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/10/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

private struct Constants{
    static let TableViewPadding = CGFloat(20)
}

class MSLocationsViewController: MSViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //this is where the lazy init is triggered. it's triggered only once
        var tableFrame = self.tableView.frame
        tableFrame.origin.x = Constants.TableViewPadding
        tableFrame.origin.y = Constants.TableViewPadding
        tableFrame.size.width = self.view.frame.width - (Constants.TableViewPadding * 2)
        tableFrame.size.height = self.view.frame.height - (Constants.TableViewPadding * 2) - 48.0
        self.tableView.frame = tableFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* broadcast a system-wide notification that the user changed the app's theme color to purple */
        let themeColor:UIColor = UIColor.init(colorLiteralRed: 0.208, green: 0.2, blue: 0.7, alpha: 1.0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GlobalStrings.GlobalThemeChanged.rawValue), object: themeColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }
    //MARK: UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "cellID"
        //try to grab a cell that's being reused. dequeue is FIFO - first in, the cell from the bottom, first out - the cell that leaves the top.
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        //if cell exists, print it and draw its label
        if let cell = cell{
            print("reused cell")
            cell.textLabel?.text = "index path row \(indexPath.row) for section \(indexPath.section)"
            return cell
        }else{
            //allocate and init the cell and draw its label
            print("new cell")
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier:identifier)
            //cell?.textLabel?.text = "index path row \(indexPath.row) for section \(indexPath.section)"
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row%2 == 0{
            
        }
    }
}
