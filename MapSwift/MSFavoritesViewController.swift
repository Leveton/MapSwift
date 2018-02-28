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

    private let cellID = "CellIdentifier"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameFilter: UISwitch!
    @IBOutlet weak var distanceFilter: UISwitch!
    @IBOutlet weak var typeFilter: UISwitch!
    
    /* guarantee that dataSource is not nil */
    var dataSource = [MSLocation](){
        didSet{
            if self.copiedDataSource == nil{
              self.copiedDataSource = self.dataSource
            }
        }
    }
    
    var copiedDataSource:Array<MSLocation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
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
        
        // if the ref to deqeueReuse is nil, create a new UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: iden) as? MSTableViewCell ?? MSTableViewCell(style: .subtitle, reuseIdentifier: iden)
        
        cell.delegate = self
        cell.location = location
        cell.mainLabel.text = location.title
        cell.subLabel.text = "dist: \(String(describing: location.distance))"
        cell.typeLabel.text = location.type
        cell.locationImageView.image = location.locationImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func distanceTypeSwitched(_ sender: Any) {
        let control = sender as! UISwitch
        
        nameFilter.isOn = false
        distanceFilter.isOn = false
        
        if control.isOn{
            let randomed:Array<MSLocation> = self.dataSource.filter{$0.type! == "Random"}
            let rested = self.dataSource.filter{$0.type! == "Restaurant"}
            let schooled = self.dataSource.filter{$0.type! == "School"}
            let started = self.dataSource.filter{$0.type! == "StartUp"}
            
            let randomTotal = randomed.reduce(0, {$0 + $1.distance})
            let restedTotal = rested.reduce(0, {$0 + $1.distance})
            let schoolTotal = schooled.reduce(0, {$0 + $1.distance})
            let startedTotal = started.reduce(0, {$0 + $1.distance})
            
            let random = combinedLocation(randomTotal, randomed)
            let school = combinedLocation(schoolTotal, schooled)
            let rest = combinedLocation(restedTotal, rested)
            let start = combinedLocation(startedTotal, started)
            
            var foo:Array<combinedLocation> = [random, school, rest, start]
            foo.sort{$0.total < $1.total}
            
            let final = foo[0].collection! + foo[1].collection! + foo[2].collection!
            
            self.dataSource = final
            
        }else{
            self.dataSource = self.copiedDataSource!
        }
        self.tableView.reloadData()
    }
    @IBAction func distanceSwitched(_ sender: Any) {
        let control = sender as! UISwitch
        
        nameFilter.isOn = false
        typeFilter.isOn = false
        
        if control.isOn{
            self.dataSource.sort{($0.distance ?? 0.0) < ($1.distance ?? 0.0)}
        }else{
            self.dataSource = self.copiedDataSource!
        }
        self.tableView.reloadData()
        
    }
    @IBAction func nameSwitched(_ sender: Any) {
        let control = sender as! UISwitch
        nameFilter.isOn = !nameFilter.isOn
        
        distanceFilter.isOn = false
        typeFilter.isOn = false
        
        if control.isOn{
            self.dataSource.sort{($0.title ?? "") < ($1.title ?? "")}
        }else{
            self.dataSource = self.copiedDataSource!
        }
        self.tableView.reloadData()
        
    }

    func switchOffOthersExcept(notMe:Int){
        nameFilter.isOn = notMe == nameFilter.tag
        distanceFilter.isOn = notMe == distanceFilter.tag
        typeFilter.isOn = notMe == typeFilter.tag
    }
    //MARK: MSTableViewCellDelegate
    
    
    func deleteButtonTappedFrom(cell: MSTableViewCell, location:MSLocation){
        var favs = UserDefaults.standard.object(forKey: "favoritesArray") as! Array<Int>
        favs.removeWithObject(object: location.locationID!)
        UserDefaults.standard.set(favs, forKey: "favoritesArray")
        self.dataSource.removeWithObject(object: location)
        self.tableView.reloadData()
    }
    
    func detailButtonTappedFrom(cell: MSTableViewCell, location: MSLocation) {
        let vc = MSLocationDetailViewController()
        vc.location = location
        vc.view.backgroundColor = UIColor.purple
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
