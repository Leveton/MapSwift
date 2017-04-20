//
//  MSLocationDetailViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/19/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSLocationDetailViewController: UIViewController {

    lazy var label:UILabel = self.newLabel()
    func newLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }
    
    var location:MSLocation?{
        didSet{
            self.label.text = location?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.label.frame = self.view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
