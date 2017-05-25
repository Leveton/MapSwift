//
//  MSLocationTableViewCell.swift
//  MapSwift
//
//  Created by Mike Leveton on 5/24/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSLocationTableViewCell: UITableViewCell {

    lazy var mainLabel:UILabel = self.newMainLabel()
    func newMainLabel() -> UILabel{
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 20)
        label.backgroundColor = UIColor.red
        self.addSubview(label)
        return label
    }
    lazy var subLabel:UILabel = self.newSubLabel()
    func newSubLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.green
        self.addSubview(label)
        return label
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mainLabel.sizeToFit()
        var mainFrame = self.mainLabel.frame
        mainFrame.origin.x = 10.0
        mainFrame.origin.y = 10.0
        //mainFrame.size.width = self.frame.size.width - 10
        self.mainLabel.frame = mainFrame
        
        self.subLabel.sizeToFit()
        var subFrame = self.subLabel.frame
        
        //maxY grabs the y offset and the height and adds them
        subFrame.origin.y = mainFrame.maxY
        self.subLabel.frame = subFrame
        
    }
}
