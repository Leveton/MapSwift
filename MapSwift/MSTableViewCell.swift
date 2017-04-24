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
    
    var location:MSLocation?{
        didSet{
            
            self.mainLabel.text = location?.title
            self.subLabel.text = location?.type
            
            if location?.locationImage != nil{
                self.locationImageView.image = location?.locationImage
            }
        }
    }
    
    lazy var mainLabel:UILabel = self.newMainLabel()
    func newMainLabel() -> UILabel{
        let label = UILabel(frame: CGRect.zero)
        /* distinguish with background color */
        label.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 234/255, alpha: 1.0)
        label.text = "mike"
        self.addSubview(label)
        return label
    }
    
    lazy var subLabel:UILabel = self.newSubLabel()
    func newSubLabel() -> UILabel{
        
        let label = UILabel(frame: CGRect.zero)
        
        /* set a custom font */
        label.font = UIFont(name: "Chalkduster", size: 12)
        
        /*distinguish with background color */
        label.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 234/255, alpha: 1.0)
        self.addSubview(label)
        return label
    }
    
    lazy var deleteButton:UIButton = self.newDeleteButton()
    func newDeleteButton() -> UIButton{
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        button.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle("Delete", for: UIControlState.normal)
        button.addTarget(self, action: #selector(didTapDelete), for: UIControlEvents.touchUpInside)
        self.addSubview(button)
        return button
    }
    
    lazy var detailsButton:UIButton = self.newDetailsButton()
    func newDetailsButton() -> UIButton{
        let button = UIButton(type: UIButtonType.custom)
        button.setTitleColor(UIColor.green, for: UIControlState.normal)
        button.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle("Details", for: UIControlState.normal)
        button.addTarget(self, action: #selector(didTapDelete), for: UIControlEvents.touchUpInside)
        self.addSubview(button)
        return button
    }
    
    lazy var locationImageView:UIImageView = self.newLocationImageView()
    func newLocationImageView() -> UIImageView{
        
        let view = UIImageView(frame: CGRect.zero)
        self.addSubview(view)
        return view
    }
    
    lazy var dividerLine:UIView = self.newDividerLine()
    func newDividerLine() -> UIView{
        
        let view = UIView()
        
        /*don't use black in a real project. google the reason why */
        view.backgroundColor = UIColor.black
        
        /* set its y index to be greater than the other subviews on the cell */
        view.layer.zPosition = 2.0
        
        self.addSubview(view)
        return view
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewHeight = self.frame.height
        
        var imageFrame = self.locationImageView.frame
        imageFrame.size.width = viewHeight
        imageFrame.size.height = viewHeight
        imageFrame.origin.x = self.frame.width - imageFrame.size.width
        /*custom method that centers a view vertically */
        imageFrame.origin.y = self.verticallyCenteredFrameForChildFrame(frame: imageFrame).origin.y
        self.locationImageView.frame = imageFrame
        
        var detailsFrame = self.detailsButton.frame
        detailsFrame.size.width = (self.frame.width - imageFrame.size.width)/2
        detailsFrame.size.height = viewHeight/2
        detailsFrame.origin.x = imageFrame.origin.x - detailsFrame.size.width
        /* the origin is 0,0 by default so no need to set it */
        self.detailsButton.frame = detailsFrame
        
        var deleteFrame = self.deleteButton.frame
        deleteFrame.size.width = (self.frame.width - imageFrame.size.width)/2
        deleteFrame.size.height = viewHeight/2
        deleteFrame.origin.x = imageFrame.origin.x - detailsFrame.size.width
        deleteFrame.origin.y = viewHeight/2
        self.deleteButton.frame = deleteFrame
        
        var mainFrame = self.mainLabel.frame
        mainFrame.size.width = (self.frame.width - imageFrame.size.width)/2
        mainFrame.size.height = viewHeight/2
        /* the origin is 0,0 by default so no need to set it */
        self.mainLabel.frame = mainFrame
        
        var subFrame = self.subLabel.frame
        subFrame.size.width = (self.frame.width - imageFrame.size.width)/2
        subFrame.size.height = viewHeight/2
        subFrame.origin.y = viewHeight/2
        self.subLabel.frame = subFrame
        
        /* good example of not just thinking of UIViews as squares but as lines or even circles */
        var dividerFrame = self.dividerLine.frame
        dividerFrame.size.width = imageFrame.origin.x
        dividerFrame.size.height = 1.0
        dividerFrame.origin.y = viewHeight - 1.0
        self.dividerLine.frame = dividerFrame
    }
    
    //MARK: selectors
    
    func didTapDelete(){
        delegate?.deleteButtonTappedFrom(cell: self)
    }
    
    func verticallyCenteredFrameForChildFrame(frame:CGRect) -> CGRect{
        var frame = frame
        let myBounds = self.bounds
        frame.origin.y = (myBounds.height/2) - (frame.height/2)
        return frame
    }
}

//MARK: MSTableViewCellDelegate

/* use 'class' to guarantee that only classes will conform to this protocol */
protocol MSTableViewCellDelegate: class {
    func deleteButtonTappedFrom(cell: MSTableViewCell)
}
