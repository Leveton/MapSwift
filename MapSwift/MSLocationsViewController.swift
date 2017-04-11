//
//  MSLocationsViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/10/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSLocationsViewController: MSViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
