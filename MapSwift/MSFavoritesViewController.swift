//
//  MSFavoritesViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/14/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

struct combinedLocation{
    var total:CGFloat!
    var collection:Array<MSLocation>!
    
    init(_ total:CGFloat, _ collection:Array<MSLocation>){
        self.total = total
        self.collection = collection
    }
}

class MSFavoritesViewController: UITableViewController, MSTableViewCellDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var typeFilter: UISwitch!
    @IBOutlet weak var distanceFilter: UISwitch!
    @IBOutlet weak var nameFilter: UISwitch!
    private let cellID = "MSTableViewCell"
    
    required init(coder:NSCoder){
        super.init(coder: coder)!
        
        /* don't put this in viewDidLoad because the it's only called if the user visits the view  */
        NotificationCenter.default.addObserver(self, selector: #selector(self.favoritesReordered(_:)), name: NSNotification.Name(rawValue: GlobalStrings.FavoritesRearranged.rawValue), object: nil)
    }
    
    /* guarantee that dataSource is not nil */
    var dataSource = [MSLocation](){
        didSet{
            if copiedDataSource == nil{
                copiedDataSource = self.dataSource
            }
        }
    }
    
    var copiedDataSource:Array<MSLocation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITableViewDelegate
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
        
        //call some method on the cell class that adjusts the z-axis of the top and bottom borders
        //e.g. cell.adjustBorders()
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    //MARK: MSTableViewCellDelegate
    
    func deleteButtonTappedFrom(cell: MSTableViewCell, location:MSLocation){
        
        /* get a mutable reference to our data source and remove the deleted location */
        var favs = UserDefaults.standard.object(forKey: "favoritesArray") as! Array<Int>
        favs.removeWithObject(object: location.locationID!)
        UserDefaults.standard.set(favs, forKey: "favoritesArray")
        self.dataSource.removeWithObject(object: location)
        
        var array = [IndexPath]()
        
        /* the parameter here is a class method to get the row that was tapped, our table has only 1 section so pass 0 */
        array.append(IndexPath(row: cell.tag, section: 0))
        
        /* triggers a .3 second animation for all UI related calls in between 'beginUpdates' and 'endUpdates' */
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: array, with: UITableViewRowAnimation.automatic)
        self.tableView.endUpdates()
        
        /**
         
         GCD method to grab the main thread and execute the block of code after .3 seconds (when endUpdates returns).
         Calling 'reloadData' outside this block would override 'beginUpdates'.
         
         */
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    
    func detailButtonTappedFrom(cell: MSTableViewCell, location: MSLocation) {
        
        /* Same code as 'didSelectRowAtIndexPath' from the last lesson */
        let vc = MSLocationDetailViewController()
        vc.isViewPresented = false
        vc.location = location
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: selectors

    //MARK: selectors
    
    //we're checking to see if copiedData source is NOT nil
    func resetDataSource(){
        if let copiedDataSource = copiedDataSource{
            print("copied!")
            self.dataSource = copiedDataSource
            self.tableView.reloadData()
        }else{
            print("failed!")
        }
    }
    
    @IBAction func nameSwitched(_ sender: Any) {
        let control = sender as! UISwitch
        control.isOn = !control.isOn
        distanceFilter.isOn = false
        typeFilter.isOn = false
        
        if control.isOn{
            //make sure title property is not nil, if it is, compare empty strings
            self.dataSource.sort{($0.title ?? "") < ($1.title ?? "")}
            self.tableView.reloadData()
        }else{
            resetDataSource()
        }
        
    }
    @IBAction func distanceSwitched(_ sender: Any) {
        //casting to UISwitch so we have access to isOn
        let control = sender as! UISwitch
        control.isOn = !control.isOn
        nameFilter.isOn = false
        typeFilter.isOn = false
        
        if control.isOn{
            self.dataSource.sort{$0.distance < $1.distance}
            self.tableView.reloadData()
        }else{
            resetDataSource()
        }
        
    }
    @IBAction func distanceTypeSwitched(_ sender: Any) {
        let control = sender as! UISwitch
        //control.isOn = !control.isOn
        nameFilter.isOn = false
        distanceFilter.isOn = false
        
        if control.isOn{
            let randomed:Array<MSLocation> = self.dataSource.filter{$0.type! == "Random"}
            let rested:Array<MSLocation> = self.dataSource.filter{$0.type! == "Restaurant"}
            let schooled:Array<MSLocation> = self.dataSource.filter{$0.type! == "School"}
            let started:Array<MSLocation> = self.dataSource.filter{$0.type! == "StartUp"}
            let hospitaled:Array<MSLocation> = self.dataSource.filter{$0.type! == "Hospital"}
            
            let randomTotal = randomed.reduce(0, {$0 + $1.distance})
            let restedTotal = rested.reduce(0, {$0 + $1.distance})
            let schoolTotal = schooled.reduce(0, {$0 + $1.distance})
            let startedTotal = started.reduce(0, {$0 + $1.distance})
            let hospitalTotal = hospitaled.reduce(0, {$0 + $1.distance})
            
            let random = combinedLocation(randomTotal, randomed)
            let school = combinedLocation(schoolTotal, schooled)
            let rest = combinedLocation(restedTotal, rested)
            let start = combinedLocation(startedTotal, started)
            let hospital = combinedLocation(hospitalTotal, hospitaled)
            
            var foo:Array<combinedLocation> = [random, school, rest, start, hospital]
            foo.sort{$0.total! < $1.total!}
            
            let finally = foo[0].collection + foo[1].collection + foo[2].collection! + foo[3].collection + foo[4].collection
            self.dataSource = finally
            self.tableView.reloadData()
            
        }else{
            resetDataSource()
        }
    }
    
    @objc func favoritesReordered(_ notification: NSNotification){
        if (notification.object != nil){
            
        }
    }
}
