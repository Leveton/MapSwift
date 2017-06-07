//
//  MSLocationDetailViewController.swift
//  MapSwift
//
//  Created by Mike Leveton on 4/19/17.
//  Copyright © 2017 mikeleveton. All rights reserved.
//

import UIKit

private struct Constants{
    static let ViewMargin      = CGFloat(10)
    static let ImageHeight     = CGFloat(245)
    static let LabelHeight     = CGFloat(50)
    static let AnimationHeight = CGFloat(20)
}

class MSLocationDetailViewController: UIViewController {
    
    var isPresented = false
    
    private var isLocationFavorited:Bool = false
    
    lazy var distanceLabel:UILabel = self.newDistanceLabel()
    func newDistanceLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        self.view.addSubview(label)
        return label
    }
    
    lazy var label:UILabel = self.newLabel()
    func newLabel() -> UILabel{
        let label = self.newDistanceLabel()
        label.isHidden = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(self.tap)
        self.view.addSubview(label)
        return label
    }
    
    lazy var tap:UITapGestureRecognizer = self.newTap()
    func newTap() -> UITapGestureRecognizer{
        let tap = UITapGestureRecognizer(target: self, action: #selector(MSLocationDetailViewController.didTapLabel))
        tap.numberOfTapsRequired = 2
        return tap
    }
    
    lazy var pan:UIPanGestureRecognizer = self.newPan()
    func newPan() -> UIPanGestureRecognizer{
        let pan = UIPanGestureRecognizer(target: self, action: #selector(MSLocationDetailViewController.didPanImageView))
        return pan
    }
    
    
    lazy var dismissButton:UIButton = self.newDismssButton()
    func newDismssButton() ->UIButton{
        let button = UIButton(type: .system)
        button.setImage(UIImage.init(named: "dismissButton"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(MSLocationDetailViewController.didTapDismiss), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    lazy var favoriteButton:UIButton = self.newFavoriteButton()
    func newFavoriteButton() ->UIButton{
        let button = UIButton(type: .system)
        button.setImage(UIImage.init(named: "dismissButton"), for: .normal)
        button.addTarget(self, action: #selector(MSLocationDetailViewController.didTapFavorite), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    lazy var imageView:UIImageView = self.newImageView()
    func newImageView() -> UIImageView{
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.pan)
        self.view.addSubview(imageView)
        return imageView
    }
    
    var location:MSLocation?{
        didSet{
            self.label.text = location?.title
            self.distanceLabel.text = NSString(format: "distance: %f", (location?.distance)!) as String
            self.imageView.image = location?.locationImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favs = UserDefaults.standard.object(forKey: "favoritesArray") as! Array<Int>
        print("favs from user defaults in viewdidload: \(favs) location: \(String(describing: location?.locationID))")
        isLocationFavorited = favs.contains((self.location?.locationID)!)
        
        if isLocationFavorited{
            self.favoriteButton.setImage(UIImage.init(named: "favoriteStar"), for: UIControlState.normal)
        }else{
            self.favoriteButton.setImage(UIImage.init(named: "favoriteStarEmpty"), for: UIControlState.normal)
        }
        self.favoriteButton.sizeToFit()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let tabController = self.presentingViewController as! MSTabBarController
//        tabController.removeLocationFromFavoritesWithLocation(location: self.location!)
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //turnary operator. thing of ? as if and : as else
        let topPadding:CGFloat = isPresented ? 0.0 : 64
        
        var imageFrame = self.imageView.frame
        imageFrame.origin.x = Constants.ViewMargin
        
        /* the status bar is 20 points */
        imageFrame.origin.y   = (Constants.ViewMargin * 2) + 20.0 + topPadding
        
        imageFrame.size.width = self.view.frame.width - (Constants.ViewMargin*2)
        imageFrame.size.height = Constants.ImageHeight
        self.imageView.frame = imageFrame
        
        var labelFrame:CGRect = self.label.frame
        labelFrame.origin.x = Constants.ViewMargin
        
        /* a core graphic helper method that gets the y-offset + the height */
        labelFrame.origin.y = imageFrame.maxY
        
        labelFrame.size.width = self.view.frame.width - (Constants.ViewMargin*2)
        labelFrame.size.height = Constants.LabelHeight
        self.label.frame = labelFrame
        
        /* here we can just re-use label frame */
        var distanceLabelFrame:CGRect = labelFrame
        distanceLabelFrame.origin.y = labelFrame.maxY
        self.distanceLabel.frame = distanceLabelFrame
        
        var dismissFrame = self.dismissButton.frame
        dismissFrame.origin.x = Constants.ViewMargin
        
        /* the status bar is 20 points */
        dismissFrame.origin.y = CGFloat(20) + topPadding
        self.dismissButton.frame = dismissFrame
        
        
        var favoriteFrame = self.favoriteButton.frame
        favoriteFrame.origin.x = self.view.frame.width - (favoriteFrame.size.width + Constants.ViewMargin)
        favoriteFrame.origin.y = 20.0 + topPadding
        self.favoriteButton.frame = favoriteFrame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: selectors
    
    func didTapLabel(){
        self.distanceLabel.isHidden = !self.distanceLabel.isHidden
        animateDistanceLabel()
    }
    
    func didPanImageView(panRecongnizer:UIPanGestureRecognizer){
        panRecongnizer.view?.center = panRecongnizer.location(in: panRecongnizer.view?.superview)
        
    }
    
    let handleDismiss = {() -> Void in
        print("completion block fired")
    }
    
    func didTapDismiss(){
        if isPresented{
          self.dismiss(animated: true, completion: handleDismiss)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        /* notice that this was logged out BEFORE "completion block fired" was logged out */
        print("reached end of didTapDismiss scope")
    }
    
    func didTapFavorite(){
        
        /*let's prevent interaction until the method returns */
        self.favoriteButton.isEnabled = false
        
        self.favoriteButton.imageView?.image = isLocationFavorited ? UIImage.init(named: "favoriteStarEmpty") : UIImage.init(named: "favoriteStar")
        
        var favs = UserDefaults.standard.object(forKey: "favoritesArray") as! Array<Int>
        print("favs from user defaults: \(favs)")
        
        /* grab our custom tabbar controller at the root of the project and cascade down */
        let tabController = self.presentingViewController as! MSTabBarController
        
        if isLocationFavorited{
            favs.removeWithObject(object: self.location!.locationID!)
            tabController.removeLocationFromFavoritesWithLocation(location: self.location!)
        }else{
            favs.append(self.location!.locationID!)
            tabController.addLocationToFavoritesWithLocation(location: self.location!)
        }
        
        UserDefaults.standard.set(favs, forKey: "favoritesArray")
        isLocationFavorited = !isLocationFavorited
        
        /* this is redundant code, so let's refactor it */
        if isLocationFavorited{
            self.favoriteButton.setImage(UIImage.init(named: "favoriteStar"), for: UIControlState.normal)
        }else{
            self.favoriteButton.setImage(UIImage.init(named: "favoriteStarEmpty"), for: UIControlState.normal)
        }
        self.favoriteButton.sizeToFit()
        
        self.favoriteButton.isEnabled = true
        
        print("favs from user defaults after mutation: \(favs)")
    }
    
    /* uncomment this if you want to see in-line block example */
    //    func didTapDismiss(){
    //        self.dismiss(animated: true, completion: {() -> Void in
    //            print("completion block fired")
    //        })
    //
    //        /* notice that this was logged out BEFORE "completion block fired" was logged out */
    //        print("reached end of didTapDismiss scope")
    //    }
    
    func animateDistanceLabel(){
        
        self.label.isUserInteractionEnabled = false
        
        var frame = self.distanceLabel.frame
        let yOffset = self.distanceLabel.isHidden ? -Constants.AnimationHeight : Constants.AnimationHeight
        frame.origin.y = frame.origin.y + yOffset
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {() -> Void in
            self.distanceLabel.frame = frame
        }, completion: {(finished) -> Void in
            /* animation complete. allow the user to toggle the label */
            self.label.isUserInteractionEnabled = finished
        })
    }
}
