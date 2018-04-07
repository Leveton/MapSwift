//
//  MSViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/10/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

/* this is our base class. the four main view controllers are decended from this one. Keep this one very light */
class MSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleThemeChange(note:)), name: NSNotification.Name(rawValue: GlobalStrings.GlobalThemeChanged.rawValue), object: nil)
        
        self.view.backgroundColor = UIColor.themeColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleThemeChange(note: Notification) {
        view.backgroundColor = note.object as? UIColor
    }
}
