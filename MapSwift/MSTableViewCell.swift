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
    
    @IBOutlet weak var dividerLine: UIView?
    @IBOutlet weak var mainLabel: UILabel?
    @IBOutlet weak var subLabel: UILabel?
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var detailsButton: UIButton?
    @IBOutlet weak var deleteButton: UIButton?
    @IBOutlet weak var locationImageView: UIImageView?
    var location:MSLocation?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: selectors
    
    @IBAction func didTapDelete(_ sender: Any) {
        if let loc = self.location{
            delegate?.deleteButtonTappedFrom(cell: self, location:loc)
        }
    }
    
    @IBAction func didTapDetail(_ sender: Any) {
        if let loc = self.location{
            delegate?.detailButtonTappedFrom(cell: self, location:loc)
        }
    }
    
}

//MARK: MSTableViewCellDelegate

/* use 'class' to guarantee that only classes will conform to this protocol */
protocol MSTableViewCellDelegate: class {
    func deleteButtonTappedFrom(cell: MSTableViewCell, location:MSLocation)
    func detailButtonTappedFrom(cell: MSTableViewCell, location:MSLocation)
}
