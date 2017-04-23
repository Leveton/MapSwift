//
//  MSTableViewCell.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/23/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

class MSTableViewCell: UITableViewCell {

    weak var delegate:MSTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: MSTableViewCellDelegate

/* use 'class' to guarantee that only classes will conform to this protocol */
protocol MSTableViewCellDelegate: class {
    
}
