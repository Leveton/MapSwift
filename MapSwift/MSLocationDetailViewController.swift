//
//  MSLocationDetailViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 5/22/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSLocationDetailViewController: MSViewController {
    
    lazy private var label:UILabel = self.newLabel()
    func newLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }
    
    lazy var button:UIButton = self.newButton()
    func newButton() -> UIButton{
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(self.didTapButton(sender:)), for: .touchUpInside)
        //button.titleLabel?.text = "dismiss"
        button.setTitle("dismiss", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        return button
    }
    
    func didTapButton(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var buttonFrame:CGRect = self.button.frame //right now this is (0,0,0,0)
        buttonFrame.origin.y = 25.0
        buttonFrame.size.width = self.view.frame.size.width
        buttonFrame.size.height = 100
        self.button.frame = buttonFrame //now it's (0,25,320,100)
        //buttonFrame.size
        //buttonFrame.origin.x, buttonFrame.origin.y
        
        //do some stuff with size and origin of buttonFrame
        //phone is roughly 350 pts wide and 540 pts tall.
        //the default origin is 0,0.
        
        //create a new frame here, to make 'label' smaller than the whole view.
        //self.label.frame = self.view.frame
        
        var labelFrame:CGRect = self.label.frame
        labelFrame.origin = CGPoint(x:20, y:100)
        labelFrame.size.width = self.view.frame.size.width - (20*2)
        labelFrame.size.height = self.view.frame.size.height - (100*2)
        //labelFrame.origin
        //labelFrame.size
        self.label.frame = labelFrame
    }
}
