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

    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        let tableView = UITableView(frame:CGRect.zero, style: .grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        
        //the class name becomes the cell id
        tableView.registerCell(MSColorTableViewCell.self)
        tableView.registerCell(MSTypeTableViewCell.self)
        tableView.registerCell(MSDistanceTableViewCell.self)
        
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
    
    func colorsCellForIndexPath(indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.reusableCell(indexPath: indexPath) as MSColorTableViewCell
        let imageView = UIImageView(image: UIImage(named: "check"))
        imageView.isHidden = true
        cell.accessoryView = imageView
        cell.textLabel?.text = self.colorsArray[indexPath.row]
        return cell
    }
    
    func typeCellForIndexPath(indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.reusableCell(indexPath: indexPath) as MSTypeTableViewCell
        cell.selectionStyle = .none
        cell.showsReorderControl = true
        cell.textLabel?.text = self.typesArray[indexPath.row]
        return cell
    }
    
    func distanceCellForIndexPath(indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.reusableCell(indexPath: indexPath) as MSDistanceTableViewCell
        let imageView = UIImageView(image: UIImage(named: "check"))
        imageView.isHidden = true
        cell.accessoryView = imageView
        cell.textLabel?.text = "foo"
        return cell
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        //only allow moving for the middle section
        if indexPath.section == Sections.TypeFilter.rawValue{
            return true
        }
        return false
    }
    
    //the table view is asking the delegate (the settings view controller) can it edit the row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == Sections.TypeFilter.rawValue{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        //for all sections return no editing style. default IF allows editing is true, is to return stop signs
        return UITableViewCellEditingStyle.none
    }
    
    //gets called when the cell has been let go
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source:String = self.typesArray[sourceIndexPath.row]
        typesArray.remove(at: sourceIndexPath.row)
        typesArray.insert(source, at: destinationIndexPath.row)
        print("source row \(sourceIndexPath.row) destin \(destinationIndexPath.row)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.ThemeColor.rawValue{
            return self.colorsCellForIndexPath(indexPath: indexPath)
        }else if indexPath.section == Sections.TypeFilter.rawValue{
            return self.typeCellForIndexPath(indexPath: indexPath)
        }else{
            return self.distanceCellForIndexPath(indexPath: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.ThemeColor.rawValue{
            return self.colorsArray.count
        }else if section == Sections.TypeFilter.rawValue{
            return self.typesArray.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func didTapEditTypes(){
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50)
        headerView.backgroundColor = MSSingleton.sharedInstance.themeColor
        
        let label = UILabel(frame: headerView.frame)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        let key:String = String(section)
        let value = self.sectionDict[key]
        
        label.text = value
        headerView.addSubview(label)
        
        if (section == Sections.TypeFilter.rawValue){
            
            let button = UIButton(type: .system)
            var editFrame = headerView.frame
            editFrame.origin.x = self.view.bounds.width - 40.0
            editFrame.size.width = 40.0
            button.frame = editFrame
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.setTitleColor(MSSingleton.sharedInstance.themeColor, for: .normal)
            button.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
            button.titleLabel?.font = UIFont(name: "Chalkduster", size: 10)
            
            /* the color for when the finger is actually on the button */
            button.setTitleColor(UIColor.blue, for: UIControlState.highlighted)
            
            button.layer.zPosition = 2.0
            button.addTarget(self, action: #selector(self.didTapEditTypes), for: UIControlEvents.touchUpInside)
            button.backgroundColor = UIColor.darkGray
            headerView.addSubview(button)
            
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Sections.ThemeColor.rawValue{
            
            var color = UIColor()
            switch indexPath.row {
            case 0:
                color = UIColor.blue
            case 1:
                color = UIColor.green
            case 2:
                color = UIColor.orange
            default:
                color = UIColor.orange
            }
            
            //posting a broadcast message that our whole app can listen to
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: GlobalStrings.GlobalThemeChanged.rawValue), object:color)
            
        }
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
