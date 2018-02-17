//
//  MSViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/10/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

/* this is our base class. the four main view controllers are decended from this one. Keep this one very light! */
class MSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.red
        
        /* listen for the notification that the app's theme color changed */
        NotificationCenter.default.addObserver(self, selector: #selector(MSViewController.handleThemeChange), name: NSNotification.Name(rawValue: GlobalStrings.GlobalThemeChanged.rawValue), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func handleThemeChange(note: Notification) {
        view.backgroundColor = note.object as? UIColor
    }
}

public enum GlobalStrings: String {
    case GlobalThemeChanged = "com.mapstack.themeWasChanged"
}
