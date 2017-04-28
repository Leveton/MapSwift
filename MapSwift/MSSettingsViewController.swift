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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.favoritesUpdated(_:)), name: NSNotification.Name(rawValue: GlobalStrings.FavoriteUpdated.rawValue), object: nil)
    }
    
    let settingsCellID = "settingsCell"
    let colorsCellID = "colorsCell"
    
    private var colorsArray = ["blue color", "green color", "orange color"]
    private var typesArray = ["Hospital", "School", "StartUp","Random","Restaurant"]
    private var distancesArray = [Double]()
    
    
    /*dictionary literals for our labels */
    let sectionTitleDictionary:[String: String] = [
        "0" : NSLocalizedString("App Theme Color", comment: ""),
        "1" : NSLocalizedString("Rearrange Favorite Types", comment: ""),
        "2" : NSLocalizedString("Set Locations Range", comment: "")
    ]
    
    let locationRangeDictionary:[String: String] = [
        "0" : NSLocalizedString("one mile", comment: ""),
        "1" : NSLocalizedString("two mile", comment: ""),
        "2" : NSLocalizedString("five mile", comment: ""),
        "3" : NSLocalizedString("ten mile", comment: ""),
        "4" : NSLocalizedString("twenty mile", comment: ""),
        "5" : NSLocalizedString("fifty mile", comment: ""),
    ]
    
    var locations = [MSLocation](){
        didSet{
            
        }
    }
    
    //MARK: getters
    
    func colorsCellForIndexPath(indexPath:IndexPath) -> UITableViewCell{
        var cell = self.tableView.dequeueReusableCell(withIdentifier: colorsCellID)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: colorsCellID)
            let imageView = UIImageView(image: UIImage(named: "check"))
            imageView.isHidden = true
            cell?.accessoryView = imageView
        }
        
        /* we can unwrap the optional because the cell is nil */
        cell!.textLabel?.text = self.colorsArray[indexPath.row]
        return cell!
    }
    
    func distanceCellForIndexPath(indexPath:IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let imageView = UIImageView(image: UIImage(named: "check"))
        imageView.isHidden = true
        cell.accessoryView = imageView
        
        /* we can unwrap the optional because the cell is nil */
        let index:String = String(indexPath.row)
        cell.textLabel?.text = self.locationRangeDictionary[index]
        return cell
    }
    
    func typeCellForIndexPath(indexPath:IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        
        /*prevent highlight upon tap */
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        /* allow cell to be reoredered */
        cell.showsReorderControl = true
        
        cell.textLabel?.text = self.typesArray[indexPath.row]
        return cell
    }
    
    lazy var tableView:UITableView = self.newTableView()
    func newTableView() -> UITableView{
        
        /* this table will be grouped - plain is the default */
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCellID)
        self.view.addSubview(tableView)
        tableView.allowsSelectionDuringEditing = true
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MSSingleton.sharedInstance.themeColor
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
        return self.sectionTitleDictionary.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.ThemeColor.rawValue{
            return self.colorsArray.count
        }
        if (section == Sections.TypeFilter.rawValue) {
            return self.typesArray.count
        }
        if (section == Sections.DistanceFilter.rawValue) {
            return self.locationRangeDictionary.keys.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* with different sizes, labels, types, etc, let's use some helpers instead of putting it all in-line */
        
        if (indexPath.section == Sections.ThemeColor.rawValue) {
            return  self.colorsCellForIndexPath(indexPath: indexPath)
        }
        
        if (indexPath.section == Sections.TypeFilter.rawValue) {
            return  self.typeCellForIndexPath(indexPath: indexPath)
        }
        
        if (indexPath.section == Sections.DistanceFilter.rawValue) {
            return  distanceCellForIndexPath(indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* this flashes the cell upon tap which is good for UX */
        tableView.deselectRow(at: indexPath, animated: true)
        
        /* toggle the cell's right-hand view hidden */
        if indexPath.section == Sections.ThemeColor.rawValue || indexPath.section == Sections.DistanceFilter.rawValue{
            let cell:UITableViewCell = self.tableView.cellForRow(at: indexPath)!
            cell.accessoryView?.isHidden = !(cell.accessoryView?.isHidden)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50)
        headerView.backgroundColor = MSSingleton.sharedInstance.themeColor
        
        let label = UILabel(frame: headerView.frame)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        let key:String = String(section)
        let value = self.sectionTitleDictionary[key]
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func favoritesUpdated(_ notification: NSNotification){
        if notification.object != nil{
            self.typesArray = notification.object as! Array
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == Sections.TypeFilter.rawValue{
            return true
        }
        return false
    }
    
    /* prevents animations on non-type cells */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == Sections.TypeFilter.rawValue{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        /*update our data source to refect the change */
        let sourceString:String = self.typesArray[sourceIndexPath.row]
        typesArray.remove(at: sourceIndexPath.row)
        typesArray.insert(sourceString, at: destinationIndexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GlobalStrings.FavoritesRearranged.rawValue), object: self.typesArray)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    //MARK: selectors
    
    func didTapEditTypes(){
        //[[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
}
